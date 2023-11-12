# my-app-k8s

```
# metallbが動かないとき、以下で解消した
systemctl stop kubelet
systemctl stop docker
iptables --flush
iptables -tnat --flush
systemctl start kubelet
systemctl start docker

# promtail: “error sending batch, will retry” status=-1 context deadline exceeded”
# When I change it to
Chain INPUT (policy ACCEPT)
# it works.
```

```
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

```
update-alternatives --config iptables
update-alternatives --set iptables /usr/sbin/iptables-legacy
```
