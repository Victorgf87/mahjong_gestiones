docker compose exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana


Obtener ips

En un cluster real:

kubectl get service mi-app-service -n mahjong

En minikube:

minikube service mi-app-service -n mahjong


kubectl rollout restart deployment rails-app -n mahjong


Esto para tener en el cluster para los secrets:
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.5/controller.yaml
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.19.5/kubeseal-linux-amd64 -O kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal


certs

kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.7.1 --set installCRDs=true
