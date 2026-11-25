#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="$(terraform output -raw aws_region)"
INSTANCE_ID="$(terraform output -raw instance_id)"
SG_ID="$(terraform output -raw security_group_id)"
ROLE_NAME="$(terraform output -raw iam_role_name)"
PROFILE_NAME="$(terraform output -raw instance_profile_name)"
DEFAULT_VPC_ID="$(aws ec2 describe-vpcs --region "$AWS_REGION" --filters "Name=is-default,Values=true" --query 'Vpcs[0].VpcId' --output text)"
INSTANCE_VPC_ID="$(aws ec2 describe-instances --region "$AWS_REGION" --instance-ids "$INSTANCE_ID" --query 'Reservations[0].Instances[0].VpcId' --output text)"
MATCHING_RULES="$(aws ec2 describe-security-groups --region "$AWS_REGION" --group-ids "$SG_ID" --query 'length(SecurityGroups[0].IpPermissions[?FromPort==`22` || ToPort==`22` || FromPort==`3389` || ToPort==`3389`])' --output text)"

for attempt in $(seq 1 30); do
  SSM_STATUS="$(aws ssm describe-instance-information --region "$AWS_REGION" --filters "Key=InstanceIds,Values=$INSTANCE_ID" --query 'InstanceInformationList[0].PingStatus' --output text 2>/dev/null || true)"
  [ "$SSM_STATUS" = "Online" ] && break
  echo "Waiting for SSM: attempt $attempt/30, status=${SSM_STATUS:-not-registered}"
  sleep 10
done

if [ "${SSM_STATUS:-}" != "Online" ]; then
  echo "ERROR: EC2 instance is not Online in Systems Manager." >&2
  exit 1
fi

COMMAND_ID="$(aws ssm send-command --region "$AWS_REGION" --instance-ids "$INSTANCE_ID" --document-name AWS-RunShellScript --comment "Project 23 IAM role S3 proof" --parameters file://ssm-commands.json --query 'Command.CommandId' --output text)"
aws ssm wait command-executed --region "$AWS_REGION" --command-id "$COMMAND_ID" --instance-id "$INSTANCE_ID"

{
  echo "=================================================="
  echo "PROJECT 23: IAM ROLE-BASED ACCESS - EVIDENCE"
  echo "Generated: $(date -u)"
  echo "=================================================="
  echo
  echo "===== TERRAFORM OUTPUTS ====="
  terraform output
  echo
  echo "===== DEFAULT VPC CHECK ====="
  echo "Default VPC:  $DEFAULT_VPC_ID"
  echo "Instance VPC: $INSTANCE_VPC_ID"
  [ "$DEFAULT_VPC_ID" = "$INSTANCE_VPC_ID" ] && echo "RESULT: PASS - Instance uses default VPC" || echo "RESULT: FAIL - VPC mismatch"
  echo
  echo "===== EC2 AND IAM PROFILE ====="
  aws ec2 describe-instances --region "$AWS_REGION" --instance-ids "$INSTANCE_ID" --query 'Reservations[0].Instances[0].{InstanceId:InstanceId,State:State.Name,VpcId:VpcId,SubnetId:SubnetId,IAMProfile:IamInstanceProfile.Arn,SecurityGroups:SecurityGroups[].GroupId}' --output table
  echo
  echo "===== INSTANCE PROFILE ROLE ====="
  aws iam get-instance-profile --instance-profile-name "$PROFILE_NAME" --query 'InstanceProfile.{Profile:InstanceProfileName,Roles:Roles[].RoleName}' --output table
  echo
  echo "===== ATTACHED ROLE POLICIES ====="
  aws iam list-attached-role-policies --role-name "$ROLE_NAME" --output table
  echo
  echo "===== INBOUND RULES ====="
  aws ec2 describe-security-groups --region "$AWS_REGION" --group-ids "$SG_ID" --query 'SecurityGroups[0].IpPermissions' --output json
  echo "Rules matching ports 22 or 3389: $MATCHING_RULES"
  [ "$MATCHING_RULES" = "0" ] && echo "RESULT: PASS - Ports 22 and 3389 are closed" || echo "RESULT: FAIL - SSH or RDP rule exists"
  echo
  echo "===== SSM COMMAND STATUS ====="
  echo "Command ID: $COMMAND_ID"
  aws ssm get-command-invocation --region "$AWS_REGION" --command-id "$COMMAND_ID" --instance-id "$INSTANCE_ID" --query '{Status:Status,ResponseCode:ResponseCode}' --output table
  echo
  echo "===== AWS CLI TEST OUTPUT FROM EC2 ====="
  aws ssm get-command-invocation --region "$AWS_REGION" --command-id "$COMMAND_ID" --instance-id "$INSTANCE_ID" --query 'StandardOutputContent' --output text
  echo "===== END OF EVIDENCE ====="
} | tee project23-proof.txt
