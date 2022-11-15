#!/bin/bash

CLUSTER="new-prod"
NEW_PROD="    certificate-authority-data: <cert>"       # Here you should paste the cert data from your ./kube/config file - you can find it on one of master nodes
NEW_RPOD_IP="<clusterIP>"       # For example "https://1.2.3.4:6443"

main(){
NS="default"
SA=$(kubectl get serviceaccounts -n $NS | awk '{print $1}')
arr=($SA)

mkdir -p "$HOME"/$CLUSTER

for i in "${arr[@]:1}"
do
TOKEN_NAME=$(kubectl get serviceaccount "$i" -o jsonpath='{.secrets[].name}')
DECODED=$(kubectl get secret "$TOKEN_NAME" -o jsonpath='{.data.token}' | base64 -d)
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
    namespace: $NS
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