
# Homelab Kubernetes Project

This repository contains a homelab setup for deploying applications on a Kubernetes cluster managed by GitOps with Flux.
The current setup includes Prometheus, Grafana, and is intended for easy addition of further applications, like Pi-hole and Home Assistant.

This setup is designed for a Raspberry Pi environment with limited resources, and the configuration is optimized to manage storage and memory constraints.

## Project Overview

- **Kubernetes Distribution**: K3s (lightweight Kubernetes for low-resource environments).
- **GitOps Operator**: Flux, for automated synchronization with this repository.
- **Metrics and Monitoring**: Prometheus and Grafana.
- **Future Applications**: Pi-hole, Home Assistant, and others.

## Setup Instructions

### Prerequisites

1. **K3s**: Ensure K3s is installed on your Raspberry Pi. This setup assumes you're using K3s as it is lightweight and suitable for Raspberry Pi environments.
2. **GitHub Access**: You'll need to add a deploy key from this repository to your GitHub settings for Flux to access it.

### Bootstrap Script

To initialize your Kubernetes cluster and install Flux, run the `bootstrap.sh` script:

```bash
./bootstrap.sh
```

This script:
- Installs K3s and sets up Kubernetes configuration.
- Installs Flux CLI.
- Bootstraps Flux, connecting this repository to your Kubernetes cluster.

**Note**: After running the bootstrap script, copy the generated public SSH key and add it as a deploy key in the GitHub repository settings, if Flux did not install it.

### Repository Structure

- `clusters/my-cluster`: Main configuration directory with subdirectories for managing Helm releases, namespaces, and Flux configurations.

#### Key Subdirectories:

- **helmrepositories**: Defines Helm repositories (like Grafana and Prometheus) as sources for Helm charts.
- **helmreleases**: Contains Helm release files for Grafana and Prometheus, with configuration for resource requests, limits, and data retention.
- **namespaces**: Creates dedicated namespaces for applications, such as Grafana and Prometheus, to isolate resources.
- **flux-system**: Holds Flux-specific configuration files to manage synchronization and GitOps setup.

### Configuration Details

#### Resource Allocation

Each application has configured resource requests and limits to optimize for limited hardware:
- **Prometheus**: Retains data for 7 days and uses up to 10Gi storage.
- **Grafana**: Limited to 10Gi storage for configuration data.

### Adding New Applications

To add new applications (e.g., Pi-hole, Home Assistant):
1. Create a new Helm release file in `helmreleases` for the application.
2. Define a namespace for the application in `namespaces`.
3. Set resource limits and retention policies if applicable.

### Monitoring and Scaling

- **Horizontal Pod Autoscaler (HPA)** can be set up for applications needing variable scaling, like Home Assistant.
- **Vertical Pod Autoscaler (VPA)** is recommended only if additional resources are available.

## Troubleshooting

- **Storage Issues**: If the SD card becomes full, reduce the Prometheus retention period or allocate more storage if possible.
- **Resource Exhaustion**: Ensure resource limits are set in Helm release files to prevent any application from monopolizing resources.

## License

This project is licensed under the MIT License.