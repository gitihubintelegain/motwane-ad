# Motwane Production Infrastructure

Production Azure infrastructure deployed using Terraform reusable modules and GitHub Actions.

<p align="center">

<img src="https://skillicons.dev/icons?i=azure,terraform,github,powershell"/>

</p>

---

## Overview

This repository contains the Infrastructure as Code (IaC) implementation for the Motwane production environment in Microsoft Azure.

The solution provides a standardized deployment model using reusable Terraform modules and GitHub Actions pipelines to provision and manage Azure infrastructure resources.

The deployment includes:

- Azure Virtual Network
- Active Directory Domain Services (AD DS)
- DNS Services
- Azure VPN Gateway
- GitHub Actions CI/CD
- Remote Terraform State Management

---

## Deployment Summary

| Property | Value |
|-----------|---------|
| Customer | Motwane Manufacturing |
| Environment | Production |
| Region | Central India |
| Infrastructure as Code | Terraform |
| CI/CD Platform | GitHub Actions |
| State Backend | Azure Storage Account |
| Identity Platform | Active Directory Domain Services |
| Connectivity | Azure VPN Gateway (VpnGw1AZ) |

---

## Architecture

> architecture image under `/assets/architecture.png`

![Architecture](./assets/architecture.png)

The environment consists of:

- Production Azure Virtual Network
- Dedicated Active Directory subnet
- Dedicated Gateway subnet
- Azure VPN Gateway for Site-to-Site connectivity
- On-Premises firewall integration
- GitHub Actions deployment automation

---

## Technology Stack

| Layer | Technology |
|---------|------------|
| Cloud Platform | Microsoft Azure |
| Infrastructure as Code | Terraform |
| Source Control | GitHub |
| CI/CD | GitHub Actions |
| Identity Services | Active Directory Domain Services |
| DNS Services | Active Directory Integrated DNS |
| Connectivity | Azure VPN Gateway |
| Automation | PowerShell |
| Authentication | Azure Service Principal |

---

## Infrastructure Components

### Networking

| Resource | Configuration |
|------------|---------------|
| Virtual Network | 172.20.0.0/22 |
| Public Subnet | 172.20.0.0/24 |
| Private Subnet | 172.20.1.0/24 |
| ADDS Subnet | 172.20.2.0/24 |
| GatewaySubnet | 172.20.3.0/26 |

### Active Directory Services

| Resource | Configuration |
|------------|---------------|
| Domain Controller | 1 |
| DNS | Active Directory Integrated |
| Deployment | Automated |
| Domain Join | Automated |

### VPN Gateway

| Resource | Configuration |
|------------|---------------|
| SKU | VpnGw1AZ |
| VPN Type | Route-Based |
| Connectivity | Site-to-Site VPN |
| Active-Active | Disabled |
| BGP | Disabled |
| Availability Zone | Zone 1 |

---

## Network Topology

> Store your network diagram under `/assets/network-topology.png`

![Network Topology](./assets/network-topology.png)

### Connectivity Flow

```text
On-Premises Network
        │
        ▼
Customer Firewall
(FortiGate / Palo Alto / Sophos / Cisco)
        │
        ▼
Site-to-Site VPN
        │
        ▼
Azure VPN Gateway
        │
        ▼
Azure Virtual Network
        │
        ├── Public Subnet
        ├── Private Subnet
        ├── ADDS Subnet
        └── GatewaySubnet
```

---

## CI/CD Pipeline

> pipeline diagram under `/assets/pipeline.png`

![Pipeline](./assets/pipeline.png)

### Deployment Workflow

```text
Terraform Validate
        │
        ▼
Terraform Plan
        │
        ▼
Terraform Apply
        │
        ▼
Deployment Validation
```

---

## Terraform Modules

This deployment leverages reusable Terraform modules.

| Module | Purpose |
|----------|----------|
| Network | Virtual Network, Subnets, NSGs |
| ADDS | Domain Controller Deployment |
| VPN Gateway | Azure VPN Gateway Deployment |

---

## Naming Convention

| Resource Type | Pattern |
|---------------|----------|
| Resource Group | client-env-region-rg-* |
| Virtual Network | client-env-region-vnet |
| Domain Controller | client-env-region-dc-* |
| VPN Gateway | client-env-region-vpngw |
| Public IP | client-env-region-pip-* |

### Examples

```text
motwane-prod-cin-rg-network

motwane-prod-cin-rg-infra

motwane-prod-cin-vnet

motwane-prod-cin-dc-01

motwane-prod-cin-vpngw

motwane-prod-cin-pip-vpngw
```

---

## Repository Structure

```text
motwane-ad

├── .github
│   └── workflows
│       └── terraform-deploy.yml
│
├── envs
│   └── prod
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── assets
│   ├── architecture.png
│   ├── network-topology.png
│   └── pipeline.png
│
└── README.md
```

---

## Security Controls

- Infrastructure as Code Governance
- Azure Service Principal Authentication
- Remote Terraform State
- GitHub Secrets Management
- Manual Production Approval Workflow
- Network Segmentation
- Dedicated Gateway Subnet

---

## Contributors

| Name | Contribution |
|--------|-------------|
| Darshan Thenge | Azure Architecture, Terraform Module Development, GitHub Actions CI/CD, Active Directory Automation, VPN Gateway Automation |

---

## License

Internal Use Only
