#!/bin/bash

# Find kubectl binary in the os path.
KUBECTL_CMD=$(which kubectl)

# Check if kubectl is installed.
if [ ! -f "$KUBECTL_CMD" ]; then
  echo "Kubernetes client (kubectl) is not installed. Please install it to continue!"

  exit 1
fi

# Check if the kubeconfig file is available.
if [ ! -f "kubeconfig" ]; then
  echo "kubeconfig file not found! You can proceed without this file!"

  exit 1
fi

# Deploy the stack (uncomment the desired deployments and services to be applied).
export KUBECONFIG=kubeconfig

$KUBECTL_CMD apply -f https://github.com/jetstack/cert-manager/releases/download/v1.11.0/cert-manager.yaml
sleep 30
$KUBECTL_CMD apply -f stack-namespaces.yaml
$KUBECTL_CMD apply -f splunk/stack-deployments.yaml
$KUBECTL_CMD apply -f splunk/stack-services.yaml
$KUBECTL_CMD apply -f ssl/letsencrypt-prod.yaml
$KUBECTL_CMD apply -f ssl/traefik-https-redirect-middleware.yaml
$KUBECTL_CMD apply -f ssl/ingress-tls.yaml


