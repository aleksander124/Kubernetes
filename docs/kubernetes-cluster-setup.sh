#!/bin/bash
systemctl disable --now ufw

{cat >> /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
modprobe overlay; modprobe br_netfilter; }

{cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system; }

{   apt update;   apt install -y containerd apt-transport-https;   mkdir /etc/containerd;   containerd config default > /etc/containerd/config.toml;   systemctl restart containerd;   systemctl enable containerd; }

{   curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -;   apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"; }

{   apt update;   apt install -y kubeadm=1.22.0-00 kubelet=1.22.0-00 kubectl=1.22.0-00; }

. kubernetes-cluster-init.sh

# add your own network for k8s cluster in my case that was calico, here is some more information about pod network https://kubernetes.io/docs/concepts/cluster-administration/addons/
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml