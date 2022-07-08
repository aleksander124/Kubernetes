# Kubernetes - Introdiution to basic kubectl commands (minikube - one node). 

[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/569/badge)](https://bestpractices.coreinfrastructure.org/projects/569)

<img src="https://github.com/kubernetes/kubernetes/raw/master/logo/logo.png" width="100">

### Requirements (I'm useing CentOS 7)
- System CentOS 7 or 8 
- A user account with sudo privileges
- Access to a terminal widow / command line 

### Content"
- [Go to *Requirements* ](https://github.com/aleksander124/containers/blob/main/kubernetes/README.md#requirements-im-useing-centos-7)
- [Go to *Minikube Installation*](https://github.com/aleksander124/containers/blob/main/kubernetes/README.md#minikube-installation)
- [Go to *Quick notes on syntax*](https://github.com/aleksander124/containers/tree/main/kubernetes#quick-notes-on-syntax)
- [Go to *Kubectl commands*](https://github.com/aleksander124/containers/tree/main/kubernetes#recommended-kubectl-commands)

---

## Minikube installation
### 1. Update the system befor instalation minikube
```
sudo yum - y update
```

### 2. Install KVM hypervisor
1. We’ll install KVM and QEMU plus some tools like libguestfs-tools and virt-top which comes in handy when administering KVM. Install them as below:
```
sudo yum -y install epel-release
sudo yum -y install gcc libvirt libvirt-devel qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
```
2. Confirm that the kernel modules are loaded:
```
sudo lsmod | grep kvm

```
> kvm_intel 147785 0 <br>
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

### 3. Install minikube 
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

### 4. Install kubectl
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

### 5. Starting minikube (Better use basic user not root)
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
---

## Quick Notes on Syntax

Before you jump into `kubectl`, it’s important to have a basic understanding of how commands are structured. All commands use the following structure in the CLI—and keeping each component in order is critical:
> kubectl [command] [TYPE] [NAME] [flags]
What does each piece mean?

### Command

The `command` portion describes what sort of operation you want to perform—namely `create`, `describe`, `get`, `apply`, and `delete`. You can perform these commands on one or more resources, since it’s possible to designate multiple resources within a single command.
- create generates new resources from files or standard input devices
- describe retrieves details about a resource or resource group
- get fetches cluster data from various sources
- delete erases resources as required
- apply pushes changes based on your configuration files

### TYPE
The `TYPE` attribute describes the kind of resource `kubectl` is targeting. What are these resources, exactly? Things like pods, services, daemonsets, deployments, replicasets, statefulsets, Kubernetes jobs, and cron jobs are critical components within the Kubernetes system. Because they impact how your deployments behave, it makes sense that you’d want to modify them.

### NAME
The `NAME` field is case sensitive and specifies the name of the resource in question. Tacking a name onto a command restricts that command to that sole resource. Omitting names from your command will pull details from all resources, like pods or jobs.

#### Flags
Finally, flags help denote special options or requests made to a certain resource. They work as modifiers that override any default values or environmental variables.
<br>
*Now, it’s time to jump into our command roundup!*

## Recommended Kubectl Commands

### 1. List all namespace services
Use this command to summon a list of all services in the current namespace:
```
kubectl get services
```

To retrieve a list of services in *all* namespaces, simply append the previous command like so:
```
kubectl get pods --all-namespaces
```

### 2. Retrieve details on your nodes
Use this command to grab a node’s overall status:
```
kubectl get nodes
```
> This grabs each node’s name, status (running, ready, inactive), roles (master, worker, controlplane, etcd), age, and Kubernetes version.

### 3. Create a new namespace with a unique name
Use this command to create a new namespace. Name it whatever you’d like (as long as that name isn’t already taken):
```
kubectl create ns hello-there
```

---
kubectl exec -it my-pod --container main-app -- /bin/bash
