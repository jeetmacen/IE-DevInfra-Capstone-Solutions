#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION first, for example: export AWS_REGION=ap-south-1}"

VPC_ID=$(aws ec2 describe-vpcs   --region "$AWS_REGION"   --filters "Name=is-default,Values=true"   --query 'Vpcs[0].VpcId'   --output text)

if [[ -z "$VPC_ID" || "$VPC_ID" == "None" ]]; then
  echo "No default VPC found in $AWS_REGION." >&2
  exit 1
fi

IGW_ID=$(aws ec2 describe-internet-gateways   --region "$AWS_REGION"   --filters "Name=attachment.vpc-id,Values=$VPC_ID"   --query 'InternetGateways[0].InternetGatewayId'   --output text)

if [[ -z "$IGW_ID" || "$IGW_ID" == "None" ]]; then
  echo "The default VPC has no attached Internet Gateway." >&2
  exit 1
fi

SUBNET_ID=$(aws ec2 describe-subnets   --region "$AWS_REGION"   --filters "Name=vpc-id,Values=$VPC_ID" "Name=state,Values=available"   --query 'sort_by(Subnets,&AvailableIpAddressCount)[-1].SubnetId'   --output text)

if [[ -z "$SUBNET_ID" || "$SUBNET_ID" == "None" ]]; then
  echo "No available subnet found in $VPC_ID." >&2
  exit 1
fi

ROUTE_OK=$(aws ec2 describe-route-tables   --region "$AWS_REGION"   --filters "Name=vpc-id,Values=$VPC_ID"   --query "length(RouteTables[].Routes[?DestinationCidrBlock=='0.0.0.0/0' && starts_with(GatewayId, 'igw-') && State=='active'][])"   --output text)

if [[ "$ROUTE_OK" == "0" || "$ROUTE_OK" == "None" ]]; then
  echo "No active 0.0.0.0/0 Internet Gateway route found in $VPC_ID." >&2
  exit 1
fi

cat > terraform.tfvars <<EOF
aws_region         = "$AWS_REGION"
existing_vpc_id    = "$VPC_ID"
existing_subnet_id = "$SUBNET_ID"
EOF

printf 'Region: %s
VPC: %s
Subnet: %s
IGW: %s
' "$AWS_REGION" "$VPC_ID" "$SUBNET_ID" "$IGW_ID"
echo "Created terraform.tfvars"
