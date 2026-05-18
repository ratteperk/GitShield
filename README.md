
## To Do:
- [x] Configure ArgoCD for GitOps-driven Kubernetes deployments
- [ ] Implement Gatekeeper policies for security enforcement
- [x] Integrate Trivy in GitHub Actions for container scanning
- [x] Deploy Prometheus for metrics 
- [x] Deploy Grafana for dashboard
- [x] Set up Alertmanager with Telegram notifications
- [x] Deploy Grafana Loki for centralized log aggregation
- [x] Containerize sample app with /health, /metrics endpoints
- [x] Demonstrate self-healing: pod failure → auto-recovery
- [x] GitHub Actions

# GitShield – GitOps Infrastructure with Monitoring and Alerting

A Kubernetes-based infrastructure project that demonstrates GitOps principles, automated deployments, monitoring, and Telegram notifications for alerts. Built as part of a university DevOps course.

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Access Services](#access-services)
- [Configuration](#configuration)
  - [Telegram Bot Setup](#telegram-bot-setup)
  - [Secrets Management](#secrets-management)
- [Project Structure](#project-structure)

---

## Overview

GitShield is a proof-of-concept infrastructure that combines:

- **GitOps workflow** with ArgoCD for declarative deployments
- **Monitoring stack** (Prometheus, Grafana, Loki) for observability
- **Alerting** via Alertmanager with Telegram notifications
- **CI/CD pipeline** using GitHub Actions and Trivy for security scanning
- **Self-healing** capabilities through Kubernetes controllers

The project runs entirely locally using Minikube, making it suitable for learning and demonstration purposes.

---

## Prerequisites

Before you begin, ensure you have the following installed:

| Tool | Version | Purpose |
|------|---------|---------|
| Docker | ≥ 20.10 | Container runtime |
| Minikube | ≥ 1.30 | Local Kubernetes cluster |
| kubectl | ≥ 1.28 | Kubernetes CLI |
| Helm | ≥ 3.12 | Package manager for Kubernetes |
| Git | ≥ 2.30 | Version control |
| Task (optional) | ≥ 3.20 | Task runner (see `Taskfile.yaml`) |

Install Minikube with Kubernetes support:

```bash
# Start minikube
minikube start --cpus=4 --memory=8g

task argocd:bootstrap
```

## Access Services

Quick setup with convenient ports:

| Service | Command to activate UI | Link to UI      | Login and password |
|---------|------------------|-----------------------|--------------------|
| ArgoCD  | `task argocd:ui` | http://localhost:8080 | `task atgocd:info` |
| Grafana | `task grafana:ui`| http://localhost:3000 | login: admin, password: admin |
| Prometheus| `kubectl port-forward svc/kube-prometheus-kube-prome-prometheus -n monitoring 9090:9090` | http://localhost:9090 | - |
| Alertmanager | `kubectl port-forward svc/alertmanager -n monitoring 9093:9093` | http://localhost:9093 | - |

## Configuration

### Telegram Bot Setup

1) Create a telegram bot
2) Get your chat ID
3) Create Kubernetes secret with bot token:

```bash
kubectl create secret generic alertmanager-telegram-secret \
  --from-literal=bot_token='YOUR_BOT_TOKEN_HERE' -n monitoring
```

4) Update Alertmanager config: Replace `chat_id` with actual ID
5) Commit and push changes
6) Restart alertmanager

```bash
kubectl delete pod -l app.kubernetes.io/name=alertmanager -n monitoring
```

7) Try test notification:
```bash
kubectl apply -f - <<EOF
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: test-telegram-alert
  namespace: monitoring
  labels:
    release: kube-prometheus
spec:
  groups:
  - name: test.rules
    interval: 30s
    rules:
    - alert: TelegramNotificationTest
      expr: vector(1) == 1
      for: 10s
      labels:
        severity: critical
      annotations:
        summary: "Test Alert"
        description: "Verifying Telegram integration"
EOF
```

8) Check your telegram

### Secrets Managment

* Bot tokens and sensitive data are stored in Kubernetes Secrets, not in Git
* Secrets are mounted as files inside pods (e.g., `/etc/alertmanager/secrets/bot_token`)
* Applications read tokens from files, not environment variables

Create a secret:
```bash
kubectl create secret generic <name> --from-literal=key=value -n <namespace>
```

## Project Structure

```bash
gitshield/
├── .github/
│   └── workflows/
│       └── ci.yml             # GitHub Actions CI/CD pipeline
├── apps/
│   ├── alertmanager.yaml      # Alertmanager Helm configuration
│   ├── gitshield-app.yaml     # Main application ArgoCD deployment
│   ├── grafana.yaml           # Grafana Helm configuration
│   └── loki.yaml              # Loki stack configuration
├── cmd/
│   └── main.go                # Go application entry point
├── k8s/
│   ├── alert-rules.yaml       # Prometheus alerting rules
│   ├── deployment.yaml        # Kubernetes deployment manifest
│   ├── hpa.yaml               # Horizontal Pod Autoscaler
│   ├── service.yaml           # Kubernetes service manifest
│   └── servicemonitor.yaml    # Prometheus ServiceMonitor
├── Dockerfile                 # Container image definition
├── go.mod                     # Go module dependencies
├── go.sum                     # Go module checksums
├── root-app.yaml              # ArgoCD root application (App-of-Apps)
├── Taskfile.yml               # Task definitions for automation
└── README.md                  # This file
```