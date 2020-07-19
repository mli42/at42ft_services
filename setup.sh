#!/bin/bash
#!/usr/env bash

############################## Turn on minikube ###############################

if ! kubectl version 2>/dev/null 1>&2 ; then
	service docker restart
	minikube start --driver=docker
	eval $(minikube docker-env -u)
fi

############################## Install Metal LB ###############################
#  Preparation

# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

#  Installation By Manifest

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

###############################################################################

services=(		\
	nginx		\
#	ftps		\
#	wordpress	\
#	mysql		\
#	phpmyadmin	\
#	grafana		\
#	influxdb	\
)

echo "Building images:"
for service in "${services[@]}"
do
	echo "	Building $service image..."
#	docker build -t $service-img ./srcs/$service >/dev/null
#	kubectl delete -f srcs/$service-deployment.yaml >/dev/null 2>&1
	echo "	Creating $service container..."
#	kubectl apply -f ./srcs/$service-deployment.yaml >/dev/null
#	while [[ $(kubectl get pods -l app=$service -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
#		sleep 1;
#	done
done
