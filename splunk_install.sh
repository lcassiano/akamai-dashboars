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
export IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
$KUBECTL_CMD apply -f https://github.com/jetstack/cert-manager/releases/download/v1.11.0/cert-manager.yaml
sleep 30
$KUBECTL_CMD apply -f stack-namespaces.yaml
$KUBECTL_CMD apply -f splunk/stack-deployments.yaml
$KUBECTL_CMD apply -f splunk/stack-services.yaml
while ! $(host $SPLUNKHOSTNAME >/dev/null); do echo "Please, configure dns hostname $SPLUNKHOSTNAME to appoint to $IPADDR"; sleep 30; done
sed -e "s|splunk@example.com|$SSLEMAIL|g" ssl/letsencrypt-prod.yaml | $KUBECTL_CMD apply -f -
$KUBECTL_CMD apply -f ssl/traefik-https-redirect-middleware.yaml
sed -e "s|splunk.example.com|$SPLUNKHOSTNAME|g" ssl/ingress-tls.yaml | $KUBECTL_CMD apply -f -
