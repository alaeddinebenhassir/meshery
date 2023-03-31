## Meshery deployement in bar metal clusters 
#
1. pull the project : 
```console
git clone https://github.com/alaeddinebenhassir/meshery.git
cd meshery
```
2. set the fellowing env vars :
```console
export WORKER_NODE="{worker-hostname}"
export MASTER_NODE="{Master-hostname}"
export WORKER_SSH_KEY="{ssh-key-location}"
```
3. Run the script
```console
chmod +x ./install/playground/Metal/clusterReset.sh
./install/playground/Metal/clusterReset.sh
```
4. checks : 

```cosole
# kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.100.94.32     139.x.x.16   80:32046/TCP,443:30530/TCP   9m43s
ingress-nginx-controller-admission   ClusterIP      10.105.236.169   <none>           443/TCP                      9m43s

```