# Project Overview

This project utilizes FluxCD to implement GitOps for managing Kubernetes cluster configurations and deployments. The repository is structured to promote clarity, scalability, and maintainability, adhering to best practices in GitOps.

## Repository Structure

The repository is organized as follows:

```
.
├── base
│   ├── namespaces
│   │   ├── backend.yaml
│   │   └── internal.yaml
│   └── nginx
│       └── release.yaml
├── clusters
│   └── dev
│       ├── flux-system
│       │   ├── gotk-components.yaml
│       │   ├── gotk-sync.yaml
│       │   └── kustomization.yaml
│       ├── harbor
│       │   └── release.yaml
│       └── kustomization.yaml
└── infrastructure
    ├── cert-manager
    │   ├── cert.yaml
    │   └── release.yaml
    ├── external-dns
    │   └── release.yaml
    └── nginx
        └── release.yaml
```

### Directory Breakdown

- **base/**: Contains foundational configurations shared across environments.
  - **namespaces/**: Defines Kubernetes namespaces.
    - `backend.yaml`: Configuration for the `backend` namespace.
    - `internal.yaml`: Configuration for the `internal` namespace.
  - **nginx/**: Holds the base release configuration for NGINX.
    - `release.yaml`: Base settings for deploying NGINX.

- **clusters/**: Environment-specific configurations.
  - **dev/**: Configurations for the development environment.
    - **flux-system/**: Contains Flux system configurations.
      - `gotk-components.yaml`: Defines Flux components.
      - `gotk-sync.yaml`: Sets up synchronization settings.
      - `kustomization.yaml`: Aggregates resources for the Flux system.
    - **harbor/**: Deployment configurations for Harbor.
      - `release.yaml`: Settings for deploying Harbor.
    - `kustomization.yaml`: Aggregates resources for the development environment.

- **infrastructure/**: Manages infrastructure components.
  - **cert-manager/**: Configurations for Cert-Manager.
    - `cert.yaml`: Certificate definitions.
    - `release.yaml`: Settings for deploying Cert-Manager.
  - **external-dns/**: Configurations for External-DNS.
    - `release.yaml`: Settings for deploying External-DNS.
  - **nginx/**: Infrastructure-specific configurations for NGINX.
    - `release.yaml`: Settings for deploying NGINX.

## Initialization Steps

To set up the environment, follow these steps:

1. **Install Custom Resource Definitions (CRDs):**

   Before deploying certain applications, ensure that their CRDs are installed. For example, to install the CRDs for the NGINX Ingress Controller:

   ```bash
   kubectl apply -f https://raw.githubusercontent.com/nginxinc/kubernetes-ingress/v4.0.0/deploy/crds.yaml
   ```

   This command applies the necessary CRDs to your cluster, preparing it for the NGINX Ingress Controller deployment.

2. **Bootstrap Flux:**

   Use the Flux CLI to bootstrap your cluster, linking it to your GitHub repository:

   ```bash
   flux bootstrap github \
     --owner=wussh \
     --repository=flux-new \
     --branch=master \
     --path=clusters/dev \
     --personal
   ```

   **Parameters:**

   - `--owner`: Your GitHub username or organization.
   - `--repository`: The name of your GitHub repository.
   - `--branch`: The branch to sync with (e.g., `master`).
   - `--path`: The directory in the repository containing the cluster configuration (`clusters/dev`).
   - `--personal`: Indicates that the repository is under a personal GitHub account.

   This command installs Flux in your cluster and sets it up to synchronize with your specified GitHub repository path.

**Note:** Ensure that your GitHub repository is accessible and contains the necessary configurations as outlined in the repository structure above.

By following this structure and initialization process, you can maintain a clear and efficient GitOps workflow using FluxCD. 