#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ $# -eq 0 ]]; then
  user_arn=$(terraform output -raw user_arn)
  simulator=(simulate-principal-policy --policy-source-arn "$user_arn")
  echo "== Principal simulation: $user_arn"
elif [[ $# -eq 1 && $1 == --policy-only ]]; then
  policy_json=$(terraform output -raw policy_json)
  simulator=(simulate-custom-policy --policy-input-list "$policy_json")
  echo "== Policy-only simulation: Terraform policy document, not effective user access"
else
  echo "Usage: bash scripts/simulate-policy.sh [--policy-only]" >&2
  exit 2
fi
bucket_arn=$(terraform output -raw bucket_arn)

simulate() {
  aws iam "${simulator[@]}" \
    --action-names "$@" \
    --query 'EvaluationResults[].[EvalActionName,EvalResourceName,EvalDecision]' --output table --no-cli-pager
}

echo "== Bucket-level actions"
simulate s3:ListBucket s3:GetBucketLocation --resource-arns "$bucket_arn"
echo "== Object-level actions"
simulate s3:GetObject s3:PutObject s3:DeleteObject --resource-arns "$bucket_arn/sample.txt"
echo "== Another bucket"
simulate s3:GetObject --resource-arns "arn:aws:s3:::some-other-bucket/sample.txt"
