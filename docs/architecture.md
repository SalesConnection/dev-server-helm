# Dev Server Architecture

This document describes the architecture of the Dev Server Helm chart and the resources it creates.

## Overview

The Dev Server Helm chart deploys containerized development environments on Kubernetes. It's designed to provide isolated environments for developers with dedicated resources, persistent storage, and SSH access.

## Component Architecture

![Dev Server Architecture](./images/architecture-diagram.png)

### Key Components

1. **User Deployments**: Individual deployments for each user
2. **Persistent Storage**: EBS volumes for user data
3. **Network Services**: Services exposing SSH and HTTP endpoints
4. **Authentication**: SSH public key authentication
5. **Resource Management**: Kubernetes resource quotas and limits

## Resource Creation

For each user defined in the values.yaml file, the chart creates:

### 1. Deployment

- Runs the development server container
- Includes init container for SSH setup
- Mounts persistent storage and configuration
- Applies resource limits and requests

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: devserver-username
spec:
  replicas: 1
  template:
    spec:
      containers:
        - name: devserver
          image: devserver-image:tag
          ports:
            - containerPort: 22  # SSH
            - containerPort: 80  # HTTP
```

### 2. Service

- Exposes SSH (port 22) and HTTP (port 80) endpoints
- Enables network access to the development environment

```yaml
apiVersion: v1
kind: Service
metadata:
  name: devserver-username
spec:
  ports:
    - port: 80
      targetPort: 80
      name: http
    - port: 22
      targetPort: 22
      name: ssh
```

### 3. PersistentVolumeClaim

- Provides persistent storage for user data
- Uses AWS EBS volumes (gp2 storage class)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: username-ebs
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: gp2
  resources:
    requests:
      storage: 30Gi
```

### 4. ConfigMap

- Stores user's public SSH key for authentication

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: username-public-key
data:
  authorized_keys: "ssh-rsa AAAA..."
```

## Topology Spread

The chart implements topology spread constraints to ensure high availability:

```yaml
topologySpreadConstraints:
  - maxSkew: 2  # Configurable via values
    topologyKey: kubernetes.io/hostname
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        service: devserver
```

This ensures that pods with the label `service: devserver` are distributed across nodes with a maximum skew defined in the values.

## Authentication Flow

1. User's public key is stored in a ConfigMap
2. Init container copies the public key to the authorized_keys file
3. SSH daemon authenticates users based on their public key
4. No password authentication is allowed

## Network Flow

1. External traffic → Kubernetes Service
2. Service routes to the appropriate pod based on selectors
3. Pod exposes SSH (22) and HTTP (80) ports
4. Internal container processes handle the connections

## Resource Management

- CPU and memory limits are configurable
- Storage size is configurable per user
- Topology spread ensures balanced distribution

## Security Considerations

- SSH access is secured with public key authentication
- Each user has an isolated environment
- Service account permissions are limited to required operations
- No root access to the host system

## Scaling Considerations

- Horizontal Pod Autoscaler can be enabled
- Resource limits prevent overutilization
- Topology spread ensures balanced load across nodes

## AWS Integration

- Uses EBS volumes for persistent storage
- Integrates with ECR for container images
- Uses IAM roles for service accounts for AWS API access
