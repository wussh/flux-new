# K3s and Flux Bootstrapping Guide

This guide provides step-by-step instructions to set up a lightweight Kubernetes cluster using [K3s](https://k3s.io/) and configure GitOps using [Flux](https://fluxcd.io/). Additionally, the guide covers installing Homebrew on Linux and configuring the necessary environment variables.

## Prerequisites

- **Operating System:** Linux or WSL (Windows Subsystem for Linux)
- **Tools:** `curl`, `bash`, and `docker`
- **GitHub Account:** Required for Flux bootstrap (with a personal repository or organization repository)
- **Sudo Privileges:** To install and configure K3s

## Installation and Configuration Steps

### 1. Install K3s

Install K3s in server mode with the following options:
- **Disable Traefik:** To avoid conflicts with other ingress controllers.
- **Writable kubeconfig:** Set to mode `644` to allow access.
- **Docker as Container Runtime:** To use Docker instead of containerd.

Run the following command:

```bash
curl -sfL https://get.k3s.io | sh -s - server \
  --disable traefik \
  --write-kubeconfig-mode 644 \
  --docker
```

### 2. Bootstrap Flux

Bootstrap Flux to enable GitOps for your cluster. This command connects your GitHub repository and deploys the necessary Flux controllers:

```bash
flux bootstrap github \
  --owner=wussh \
  --repository=flux-new \
  --branch=master \
  --path=clusters/dev \
  --personal \
  --components=source-controller,kustomize-controller,helm-controller,notification-controller \
  --components-extra=image-reflector-controller,image-automation-controller
```

**Explanation of parameters:**
- `--owner`: Your GitHub username or organization name.
- `--repository`: The name of your repository where Flux configuration will be stored.
- `--branch`: The branch in your repository to use (e.g., `master`).
- `--path`: The directory path in the repository for the cluster configurations.
- `--personal`: Indicates that you are using a personal GitHub repository.
- `--components`: List of essential Flux controllers to install.
- `--components-extra`: Additional controllers for image automation.

### 3. Set the K3s Token

Set the `K3S_TOKEN` environment variable which is used by worker nodes to join the cluster. Replace `kocakgeming` with your actual token if necessary:

```bash
export K3S_TOKEN=kocakgeming
```

### 4. Install Homebrew on Linux

Homebrew is a popular package manager. Install it using:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, configure your shell environment:

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### 5. Configure `kubectl` Access

Set the `KUBECONFIG` environment variable so that `kubectl` can interact with your K3s cluster:

```bash
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

## Verifying the Installation

After completing the steps, verify your cluster status with:

```bash
kubectl get nodes
```

For Flux-related resources, check the Flux system namespace:

```bash
kubectl get pods -n flux-system
```

## Troubleshooting

- **K3s Installation:** If K3s fails to install, review the logs located at `/var/log/syslog` or use `journalctl -u k3s`.
- **Flux Issues:** Ensure that your GitHub token and repository permissions are correctly configured.
- **Environment Variables:** Double-check that `KUBECONFIG` and `K3S_TOKEN` are correctly set in your shell.

## Additional Resources

- [K3s Documentation](https://k3s.io/)
- [Flux CD Documentation](https://fluxcd.io/)
- [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux)