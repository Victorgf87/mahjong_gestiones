docker compose exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana


Obtener ips

En un cluster real:

kubectl get service mi-app-service -n mahjong

En minikube:

minikube service mi-app-service -n mahjong
