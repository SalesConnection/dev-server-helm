# Contributing to Dev Server Helm Chart

Thank you for your interest in contributing to the Dev Server Helm Chart project! This document provides guidelines and instructions for contributing.

## Development Environment Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd dev-server-helm
   ```

2. Install required tools:
   - [Helm](https://helm.sh/docs/intro/install/) (v3.0+)
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)
   - [helm-docs](https://github.com/norwoodj/helm-docs) (optional, for documentation generation)

3. Set up a Kubernetes cluster for testing:
   - Use [minikube](https://minikube.sigs.k8s.io/docs/start/) or [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) for local testing
   - Or connect to an existing Kubernetes cluster

## Making Changes

### Chart Structure

The Helm chart is located in the `charts/devserver` directory with the following structure:

```
charts/devserver/
├── Chart.yaml           # Chart metadata
├── values.yaml          # Default configuration values
├── templates/           # Kubernetes resource templates
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── pvc.yaml
│   └── ...
└── ...
```

### Development Workflow

1. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes to the chart files.

3. Test your changes:
   ```bash
   # Validate the chart
   helm lint charts/devserver

   # Test template rendering
   helm template charts/devserver

   # Install the chart in a test environment
   helm install test-release charts/devserver --dry-run
   ```

4. Update documentation if necessary:
   - Update README.md
   - Update values.yaml comments
   - If using helm-docs, run `helm-docs` to update generated documentation

5. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

6. Push your branch and create a pull request:
   ```bash
   git push origin feature/your-feature-name
   ```

## Pull Request Guidelines

When submitting a pull request:

1. Provide a clear description of the changes and their purpose
2. Include any relevant issue numbers in the PR description
3. Ensure all tests pass
4. Update documentation to reflect your changes
5. Follow the existing code style and conventions

## Testing

### Manual Testing

Test your changes by installing the chart in a Kubernetes environment:

```bash
# Install with default values
helm install test-release charts/devserver

# Install with custom values
helm install test-release charts/devserver -f custom-values.yaml
```

Verify that all resources are created correctly:

```bash
kubectl get all -l app.kubernetes.io/instance=test-release
```

### Automated Testing

If the repository includes automated tests, run them before submitting your PR:

```bash
# Run chart tests
helm test test-release
```

## Versioning

We follow [Semantic Versioning](https://semver.org/) for the chart:

- Increment the PATCH version for backwards-compatible bug fixes
- Increment the MINOR version for new functionality in a backwards-compatible manner
- Increment the MAJOR version for incompatible changes

Update the version in `Chart.yaml` accordingly.

## Release Process

The chart is released through the following process:

1. Update the version in `Chart.yaml`
2. Update the CHANGELOG.md file
3. Create a tag matching the chart version
4. The CI/CD pipeline will package and publish the chart

## Code of Conduct

Please be respectful and inclusive when contributing to this project. We expect all contributors to adhere to professional standards of conduct.

## Questions?

If you have any questions or need help, please open an issue in the repository.

Thank you for contributing to the Dev Server Helm Chart project!
