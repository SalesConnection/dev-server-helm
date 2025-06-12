# Dev Server Helm Chart

A Helm chart for deploying development servers on Kubernetes. This chart creates individual development environments for users with SSH access, persistent storage, and configurable resources.

## Overview

The Dev Server Helm chart deploys containerized development environments for multiple users. Each user gets:

- A dedicated deployment with SSH access
- Persistent storage via EBS volumes
- Configurable resource limits
- Public key authentication

The chart is designed to run on AWS EKS clusters and integrates with AWS services like ECR for container images and EBS for storage.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- AWS EKS cluster
- AWS ECR repository for container images
- AWS IAM roles for service accounts configured

## Installation

```bash
# Add the repository (if hosted in a Helm repository)
# helm repo add devserver-repo <repository-url>
# helm repo update

# Install the chart
helm install devserver ./charts/devserver -f values.yaml
```

## Configuration

### User Configuration

Users are defined in the `values.yaml` file. Each user entry creates a separate deployment with its own persistent storage.

```yaml
users:
  - name: username
    storage: 30Gi  # Storage size for the user's persistent volume
    serviceAccount: dev-server  # Optional, defaults to the chart's service account
    public_key: ssh-rsa AAAA...  # User's SSH public key for authentication
```

### Image Configuration

```yaml
image:
  repository: <account-id>.dkr.ecr.<region>.amazonaws.com/devserver-base-image
  pullPolicy: IfNotPresent
  tag: "latest"  # Specify a version tag
```

### Service Account Configuration

```yaml
serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::<account-id>:role/<role-name>"
  name: "dev-server"
```

### Topology Spread Configuration

The chart supports pod topology spread constraints to ensure high availability:

```yaml
topologySpread:
  maxSkew: 2  # Maximum skew between nodes
```

## Architecture

The chart creates the following resources for each user:

1. **Deployment**: Runs the development server container
2. **Service**: Exposes SSH (port 22) and HTTP (port 80) endpoints
3. **PersistentVolumeClaim**: Provides persistent storage for user data
4. **ConfigMap**: Stores user's public SSH key

The deployment includes:
- An init container that sets up SSH authentication
- The main container running the development environment
- Volume mounts for persistent storage and configuration

## Topology Spread Constraints

The chart includes topology spread constraints to ensure pods are distributed across nodes:

```yaml
topologySpreadConstraints:
  - maxSkew: <configurable via values>
    topologyKey: kubernetes.io/hostname
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        service: devserver
```

This ensures that pods with the label `service: devserver` are distributed across nodes with a maximum skew defined in the values.

## Customization

### Resource Limits

```yaml
resources:
  limits:
    cpu: 1000m
    memory: 2Gi
  requests:
    cpu: 500m
    memory: 1Gi
```

### Autoscaling

```yaml
autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 80
```

## Upgrading

To upgrade an existing deployment:

```bash
helm upgrade devserver ./charts/devserver -f values.yaml
```

## Uninstallation

```bash
helm uninstall devserver
```

Note: This will not delete the PersistentVolumeClaims to prevent data loss. To delete them:

```bash
kubectl delete pvc -l app.kubernetes.io/instance=devserver
```

## License

Copyright © 2025
