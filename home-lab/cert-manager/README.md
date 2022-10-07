1. Create metallb with one ip address (if you want to only one ingress controller)
2. Create subdomain name olny for kubernetes cluster like *.k8s.home-lab.local
3. Create white card for your metallb ip for ex.    @      IN      A       192.168.1.150
4. Create Ingress Controller in my home lab i will use traefik ingress controller but you can use each ever u want
5. Remember to set change type of servis Ingress Controller to LoadBalancer to obtain a external IP of your metallb cluster
6. Check your Ingress controller details        # kubectl get ingresscontrollers -n namespace
7. 