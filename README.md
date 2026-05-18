
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

| Service | Command to activate UI | Link to UI      |
|---------|------------------|-----------------------|
| ArgoCD  | `task argocd:ui` | http://localhost:8080 |
| Grafana | `task grafana:ui`| http://localhost:3000 |
| Prometheus| `kubectl port-forward svc/kube-prometheus-kube-prome-prometheus -n monitoring 9090:9090` | http://localhost:9090 |
| Alertmanager | `kubectl port-forward svc/alertmanager -n monitoring 9093:9093` | http://localhost:9093 |

## Configuration

### Telegram Bot Setup

### Secrets Managment

## Project Structure