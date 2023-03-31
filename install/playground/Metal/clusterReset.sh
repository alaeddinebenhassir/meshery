#!/bin/bash
# reseting the cluster : 
kubeadm reset -f
kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
cp  /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
# cleannig the node && joining the worker node
ssh -o BatchMode -i $WORKER_SSH_KEY root@$WORKER_NODE -- "kubeadm reset -f && iptables -F && $(kubeadm token create --print-join-command)"
 # untaint the master node 
kubectl taint node $MASTER_NODE node-role.kubernetes.io/control-plane:NoSchedule-
# installing the networking pluging flannel 8
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
# give services some time to get ready 
sleep 5
# installing Meshery 
kubectl create ns meshery
kubectl -n meshery apply -f install/deployment_yamls/k8s
# metallb installation : source // metallb official documentaion
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system
# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
# installing by manifest 
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
sleep 5 
# creating IP pool 
kubectl create -f install/playground/Metal/ip_pool.yaml
# Exposing meshery with service Type NodePort
kubectl -n meshery   delete svc meshery  # by defaut the installation exposes meshery with loadbalancer type .
kubectl -n meshery   expose deploy meshery  --port 9082 --target-port 8080 # cluster IP is enough 
# nginx-controller installtion
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
sleep 10
#kubectl -n meshery  create ingress meshery --rule="demo.meshery.io/*=meshery:9082" --class nginx
# cert manager installtion 
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.yaml
kubectl create -f install/playground/Metal/ssl_issuer.yaml  # letsencrypt issuer 
# createing the ingress rull :
kubectl create -f install/playground/Metal/ingress.yaml
