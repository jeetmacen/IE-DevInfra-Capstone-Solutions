# Project 20 - Application Load Balancer

## Goal

Distribute HTTP traffic across two EC2 web servers in separate Availability Zones with an Application Load Balancer.

Project 16 uses an ALB to demonstrate HTTPS with ACM. Here the goal is to show that both healthy backends answer requests; no certificate or new network is required. Terraform reuses the region's default VPC and two existing default subnets. See the `network prerequisites` before deploying.

## Deliverable / output

- Healthy target instances and responses from multiple backends.
- Target-group and curl evidence in `p20_output/`.


