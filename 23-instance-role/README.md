# Project 23 Terraform Bundle

Quick start:
```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
chmod +x collect-proof.sh
./collect-proof.sh
```

Cleanup:
```bash
terraform destroy
```
