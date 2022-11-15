#!/bin/bash

#-------------------------------Insturciton-------------------------------#
# 1. To run this script you should be logged in one of master nodes       #
#     of create own context on wirtual machine                            #
# 2. Paste there correct values befor run this script                     #
# 3. The case is to get all service accounts in separeted files witch     #
#    secrets and contexts. After start you should get all files you want  #
#-------------------------------------------------------------------------#
#-------------------------author: Aleksander Okoń-------------------------#

CLUSTER="<name of cluster>"             # For example "new-prod"
NEW_PROD="    certificate-authority-data: <cert>"       # Here you should paste the cert data from your ./kube/config file - you can find it on one of master nodes
NEW_RPOD_IP="<clusterIP>"       # For example "https://1.2.3.4:6443"

main(){
NS="default"    # here type namespace where service account is located by default it is "default"
SA=$(kubectl get serviceaccounts -n $NS | awk '{print $1}')
arr=($SA)           # Creates array with all service accounts on in your cluster

mkdir -p "$HOME"/$CLUSTER           # Create folder In your home dir if not already exists 

for i in "${arr[@]:1}"
do
TOKEN_NAME=$(kubectl get serviceaccount "$i" -o jsonpath='{.secrets[].name}')
DECODED=$(kubectl get secret "$TOKEN_NAME" -o jsonpath='{.data.token}' | base64 -d)

# creates files for each user and saves the full structure as in .kube/config
# tee should additionally display output on the screen can be changed to "cat"


tee "$HOME/$CLUSTER/$i-$CLUSTER.yaml" <<EOF             
apiVersion: v1
clusters:
- cluster:
$NEW_PROD
    server: $NEW_RPOD_IP
  name: $CLUSTER
contexts:
- context:
    cluster: $CLUSTER
    namespace: default
    user: $i-$CLUSTER
  name: $CLUSTER
current-context: $CLUSTER
kind: Config
preferences: {}
users:
- name: $i-$CLUSTER
  user:
    token: $DECODED
EOF
done
}

main