#!/bin/bash
set -eu

TARGET_BRANCH=main
KUBE_API_SERVER_VIP=192.168.11.100
# Use one minor version before the latest.
KUBE_VERSION=1.28.3

kubeadm config images pull

curl -sS https://webinstall.dev/k9s | bash
echo "source ~/.config/envman/PATH.env" >> ~/.bashrc
rm -rf ~/Downloads

KUBEADM_BOOTSTRAP_TOKEN=$(openssl rand -hex 3).$(openssl rand -hex 8)

cat > ~/init_kubeadm.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
bootstrapTokens:
- token: "$KUBEADM_BOOTSTRAP_TOKEN"
  description: "kubeadm bootstrap token"
  ttl: "24h"
nodeRegistration:
  criSocket: "unix:///var/run/containerd/containerd.sock"
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
networking:
  serviceSubnet: "10.96.0.0/16"
  podSubnet: "10.128.0.0/16"
kubernetesVersion: "v${KUBE_VERSION}"
controlPlaneEndpoint: "${KUBE_API_SERVER_VIP}:8443"
controllerManager:
  extraArgs:
    bind-address: "0.0.0.0"
scheduler:
  extraArgs:
    bind-address: "0.0.0.0"
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: "systemd"
protectKernelDefaults: true
EOF

kubeadm init --config ~/init_kubeadm.yaml --skip-phases=addon/kube-proxy

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium \
    --version 1.14.4 \
    --namespace kube-system \
    --set k8sServiceHost=${KUBE_API_SERVER_VIP} \
    --set k8sServicePort=8443

# ArgoCD Install
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd \
    --version 5.51.4 \
    --create-namespace \
    --namespace argocd \
    --values https://raw.githubusercontent.com/megutamago/my-app-k8s/"${TARGET_BRANCH}"/k8s-manifests/argocd-helm-chart-values.yaml
helm install argocd argo/argocd-apps \
    --version 1.4.1 \
    --values https://raw.githubusercontent.com/megutamago/my-app-k8s/"${TARGET_BRANCH}"/k8s-manifests/argocd-apps-helm-chart-values.yaml

# ArgoCD case: PrivateRepository
#cat > ~/work/argocd_secret.yaml <<EOF
#apiVersion: v1
#kind: Secret
#metadata:
#  name: private-repo-creds
#  namespace: argocd
#  labels:
#    argocd.argoproj.io/secret-type: repo-creds
#stringData:
#  type: git
#  url: https://github.com/megutamago
#  password: <token>
#  username: megutamago
#EOF

#kubectl apply -f ~/work/argocd_secret.yaml

KUBEADM_UPLOADED_CERTS=$(kubeadm init phase upload-certs --upload-certs | tail -n 1)

cat > ~/join_kubeadm_cp.yaml <<EOF
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: "systemd"
protectKernelDefaults: true
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: JoinConfiguration
nodeRegistration:
  criSocket: "/var/run/containerd/containerd.sock"
discovery:
  bootstrapToken:
    apiServerEndpoint: "${KUBE_API_SERVER_VIP}:8443"
    token: "$KUBEADM_BOOTSTRAP_TOKEN"
    unsafeSkipCAVerification: true
controlPlane:
  certificateKey: "$KUBEADM_UPLOADED_CERTS"
EOF

cat > ~/join_kubeadm_wk.yaml <<EOF
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: "systemd"
protectKernelDefaults: true
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: JoinConfiguration
nodeRegistration:
  criSocket: "/var/run/containerd/containerd.sock"
discovery:
  bootstrapToken:
    apiServerEndpoint: "${KUBE_API_SERVER_VIP}:8443"
    token: "$KUBEADM_BOOTSTRAP_TOKEN"
    unsafeSkipCAVerification: true
EOF