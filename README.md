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

# grafana password
# id: grafana
# pw: grafana

# minio password
# id: minio
# pw: minio123

# IP
# 192.168.11.140 argocd
# 192.168.11.141 grafana
# 192.168.11.142 prometheus
# 192.168.11.143 minio
# 192.168.11.144 loki
# 192.168.11.145 tempo
```