# Kubernetes - Introdiution to basic kubectl commands. 

![kubectl logo](./images/kubectl-logo-medium.png)

### Requirements (I'm useing CentOS 7)
- System CentOS 7 or 8 
- A user account with sudo privileges
- Access to a terminal widow / command line 

### Content"
- [Go to *Requirements* ](https://github.com/aleksander124/containers/blob/main/kubernetes/README.md#requirements-im-useing-centos-7)
- [Go to *Minikube Installation*](https://github.com/aleksander124/containers/blob/main/kubernetes/README.md#minikube-installation)
- [Go to *Important Commands*](https://github.com/aleksander124/containers/blob/main/kubernetes/README.md#important-commands-for-minikube)

### Minikube installation
#### 1. Update the system befor instalation minikube
```
sudo yum - y update
```

#### 2. Install KVM hypervisor
1. We’ll install KVM and QEMU plus some tools like libguestfs-tools and virt-top which comes in handy when administering KVM. Install them as below:
```
sudo yum -y install epel-release
sudo yum -y install gcc libvirt libvirt-devel qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
```
2. Confirm that the kernel modules are loaded:
```
$ sudo lsmod | grep kvm
```
> kvm_intel 147785 0
> kvm 464964 1 kvm_intel
3. Start and enable libvirtd service:
```
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```
4. You user should be part of libvirt group.
```
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
```

#### 3. Install minikube 
1. Download the Minikube binary package using the `wget` command:
```
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```
2. Then, use the `chmod` command to give the file executive permission:
```
chmod +x minikube-linux-amd64
```
3. Finally, move the file to the `/usr/local/bin` directory:
```
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
```
4. With that, you have finished setting up Minikube. Verify the installation by checking the version of the software:
```
minikube version
```

#### 4. Install kubectl
1. We need kubectl which is a command-line tool used to deploy and manage applications on Kubernetes.
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
```
2. Give the file executable bit and move to a location in your PATH.
```
chmod +x kubectl
sudo mv kubectl  /usr/local/bin/
```
3. Confirm the version of kubectl installed.
```
kubectl version
```

#### 5. Starting minikube (Better use basic user not root)
1. Add your username to libvirt group:
```
sudo usermod -aG libvirt $USER
```
2. To create a minikube VM with the default options, run:
```
minikube start
```
3. The default container runtime to be used is docker, but you can also use crio or containerd:
```
minikube start --container-runtime=cri-o
minikube start --container-runtime=containerd
```
5. (**IMPORTANT**) If you have more than one hypervisor, then specify it. 
```
minikube start --vm-driver kvm2
```

### Important commands for minikube 