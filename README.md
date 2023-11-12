# my-app-k8s

```
# metallbが動かないとき、以下で解消した
systemctl stop kubelet
systemctl stop docker
iptables --flush
iptables -tnat --flush
systemctl start kubelet
systemctl start docker

# argocd password
# id: admin
# pw: admin
```