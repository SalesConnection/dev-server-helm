# Dev Server User Guide

This guide provides instructions for users of the Dev Server environment deployed with the Helm chart.

## Overview

The Dev Server provides a containerized development environment with:

- SSH access
- Persistent storage
- Development tools and utilities
- HTTP access for web applications

## Accessing Your Dev Server

### SSH Access

Connect to your development server using SSH:

```bash
ssh <username>@<server-hostname>
```

Authentication is done using SSH public key authentication. Your public key must be registered with the system administrator before you can access the server.

### Port Forwarding

To access services running on your development server:

```bash
# Forward local port 8080 to port 80 on your dev server
ssh -L 8080:localhost:80 <username>@<server-hostname>
```

## Working with Your Environment

### Persistent Storage

Your home directory (`/root`) is backed by persistent storage. Files stored here will persist across pod restarts and redeployments.

### Development Tools

The development environment comes with pre-installed tools:

- Git
- Docker
- Python
- Node.js
- Common development utilities

### Running Web Applications

Web applications running on port 80 inside your container can be accessed through the service endpoint or through port forwarding.

## Best Practices

### Resource Usage

Be mindful of resource usage:

- Monitor CPU and memory usage with `top` or `htop`
- Clean up unused Docker containers and images
- Remove temporary files when no longer needed

### Data Backup

While your data is stored on persistent volumes, it's good practice to:

- Push code to remote repositories regularly
- Back up important configuration files
- Document your environment setup

### Security

Follow these security best practices:

- Keep your SSH keys secure
- Use strong passwords for services within your environment
- Don't expose sensitive information in web applications

## Troubleshooting

### Connection Issues

If you cannot connect to your development server:

1. Verify your SSH key is correctly registered
2. Check with your administrator that your pod is running
3. Ensure you're using the correct hostname and username

### Storage Issues

If you encounter storage problems:

1. Check available disk space with `df -h`
2. Contact your administrator if you need more storage allocated

### Pod Restarts

If your environment keeps restarting:

1. Check resource usage - you might be hitting resource limits
2. Review logs for any application errors
3. Contact your administrator with details of the issue

## Getting Help

For assistance with your development environment:

1. Check this documentation
2. Contact your system administrator
3. File an issue in the support system with details of your problem

## FAQ

**Q: Can I install additional software?**
A: Yes, you can install additional software within your container. However, these changes will not persist if the container image is updated.

**Q: How do I request more resources?**
A: Contact your administrator to request changes to CPU, memory, or storage allocations.

**Q: Can I access other services in the cluster?**
A: This depends on the network policies in place. Consult your administrator for specific access requirements.
