# IronClad Requirements

## Introduction

This document outlines the comprehensive setup and management requirements for the IronClad project, aiming to establish a robust Continuous Integration/Continuous Delivery (CI/CD) pipeline. 

## Technical Stack

IronClad utilizes a range of technologies and tools to create a scalable and efficient CI/CD pipeline:

- **Version Control**: GitHub for source code management and version control.
- **CI/CD**: Jenkins for automating the build, test, and deployment processes.
- **Repository Management**: Nexus for managing project artifacts and dependencies.
- **Containerization**: Docker for creating and managing containerized application components.
- **Orchestration**: Kubernetes for automating deployment, scaling, and management of containerized applications.
- **Code Quality**: SonarQube for continuous inspection of code quality.
- **Vulnerability Scanning**: Trivy for scanning containers for vulnerabilities.
- **Monitoring**: Grafana and Prometheus for monitoring and visualizing metrics.
- **Infrastructure as Code (IaC)**: Terraform for provisioning and managing infrastructure.
- **Configuration Management**: Ansible for automating software provisioning, configuration management, and application deployment.

## Infrastructure Requirements

The IronClad infrastructure is designed to be modular and scalable, accommodating various components of the CI/CD pipeline:

### Networking & Security

- **Resource Group**: `ironclad-rg` - Central management for all IronClad resources.
- **Virtual Network (VNet)**: `ironclad-vnet` - A dedicated virtual network to securely connect Azure infrastructure components.
- **Subnets**: Segmented network subnets within the VNet for organizing resources.
    - `ironclad-subnet-private` for Jenkins, Nexus, and SonarQube VMs.
    - `ironclad-subnet-public` for resources that require external access.
- **Network Security Groups (NSGs)**: NSGs for enforcing security rules and controlling access to resources.

  - `ironclad-nsg-private` for VMs in the private subnet.
  - `ironclad-nsg-public` for the public subnet.

### Compute Resources

- **Virtual Machines (VMs)**: Separate VMs for Jenkins, Nexus, and SonarQube, ensuring isolated environments for each tool.
    - **Jenkins VM**: `jenkins-vm` - Hosts Jenkins for automation.
    - **Nexus VM**: `nexus-vm` - Manages artifact storage.
    - **Security VM**: `security-vm` - Conducts code quality checks and image scans.
    - **Monitoring VM**: `monitoring-vm` hosting both Prometheus and Grafana
    - **Jump Server**: `jump-vm` located in `ironclad-subnet-public`, used for secure SSH/RDP access to the private subnet.


### Container Orchestration

- **Kubernetes Cluster**: `ironclad-aks-cluster` - A Kubernetes cluster for orchestrating container deployment, scaling, and management.

## CI/CD Pipeline Flow

1. **Code Commit**: Developers push code changes to GitHub, triggering the CI/CD pipeline.
2. **Build**: Jenkins retrieves the latest code and performs build tasks.
3. **Test**: Automated tests are executed to ensure code quality and functionality.
4. **Quality Check**: Code is analyzed by SonarQube, and container images are scanned by Trivy for vulnerabilities.
5. **Deployment**: Jenkins deploys the application to the Kubernetes cluster using Docker images.
6. **Monitoring**: Application and infrastructure performance are monitored using Prometheus and Grafana.