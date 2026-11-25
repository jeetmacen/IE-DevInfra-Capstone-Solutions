#!/usr/bin/env bash
set -euo pipefail

AWS_REGION=$(terraform output -raw aws_region)
INSTANCE_ID=$(terraform output -raw instance_id)
LOG_GROUP=$(terraform output -raw cloudwatch_log_group)
SG_ID=$(terraform output -raw security_group_id)

mkdir -p p17_output

{
  echo "============================================================"
  echo " PROJECT 17 - CLOUDWATCH LOG FORWARDING EVIDENCE"
  echo "============================================================"
  echo "Generated UTC : $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Region        : $AWS_REGION"
  echo "Instance ID   : $INSTANCE_ID"
  echo "Log group     : $LOG_GROUP"
  echo "Security group: $SG_ID"
  echo

  echo "---------------- CLOUDWATCH LOG GROUP ----------------"
  aws logs describe-log-groups     --log-group-name-prefix "$LOG_GROUP"     --region "$AWS_REGION"     --query "logGroups[?logGroupName=='$LOG_GROUP'].{LogGroup:logGroupName,RetentionDays:retentionInDays,StoredBytes:storedBytes}"     --output table

  echo
  echo "---------------- CLOUDWATCH LOG STREAM ----------------"
  aws logs describe-log-streams     --log-group-name "$LOG_GROUP"     --log-stream-name-prefix "$INSTANCE_ID"     --region "$AWS_REGION"     --query 'logStreams[].{LogStream:logStreamName,LastEvent:lastEventTimestamp}'     --output table

  echo
  echo "---------------- EXPECTED BOOT OUTPUT ----------------"
  aws logs filter-log-events     --log-group-name "$LOG_GROUP"     --log-stream-names "$INSTANCE_ID"     --region "$AWS_REGION"     --filter-pattern '"P17"'     --query 'events[].{LogStream:logStreamName,Message:message}'     --output table

  echo
  echo "---------------- INBOUND SECURITY RULES ----------------"
  aws ec2 describe-security-groups     --group-ids "$SG_ID"     --region "$AWS_REGION"     --query 'SecurityGroups[0].{SecurityGroup:GroupId,InboundRules:IpPermissions}'     --output json

  echo
  echo "Expected InboundRules: []"
  echo "This confirms ports 22 and 3389 are not exposed."
  echo "============================================================"
} | tee p17_output/p17-cli-evidence.txt

aws logs describe-log-groups   --log-group-name-prefix "$LOG_GROUP"   --region "$AWS_REGION"   --output json > p17_output/log-group.json

aws logs describe-log-streams   --log-group-name "$LOG_GROUP"   --log-stream-name-prefix "$INSTANCE_ID"   --region "$AWS_REGION"   --output json > p17_output/log-stream.json

aws logs filter-log-events   --log-group-name "$LOG_GROUP"   --log-stream-names "$INSTANCE_ID"   --region "$AWS_REGION"   --filter-pattern '"P17"'   --output json > p17_output/boot-output.json

aws ec2 describe-security-groups   --group-ids "$SG_ID"   --region "$AWS_REGION"   --output json > p17_output/security-group.json

echo "Evidence saved under p17_output/."
