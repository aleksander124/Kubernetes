```shell
kubectl patch crd/MY_CRD_NAME -p '{"metadata":{"finalizers":[]}}' --type=merge

kubectl top pods --all-namespaces | sort --key 4 --numeric --reverse

kubectl run curl-test --image=odise/busybox-curl --rm -it -- /bin/sh -c "while true; do curl web-service; sleep 1; done"
```