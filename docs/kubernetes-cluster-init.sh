#!/bin/bash
sudo kubeadm init \
  --pod-network-cidr=172.16.0.0/16 \               # !!! Important this subnet cant overlap your subnet 
  --cri-socket unix:///run/containerd/containerd.sock \         # for containerd runtime
  --control-plane-endpoint 192.168.1.110 \          # in my case that was my endpoint but you can specify any other ip like ha ip
  --upload-certs \
  --dry-run