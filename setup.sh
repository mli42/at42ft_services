#!/usr/bin/zsh
#!/usr/env zsh

############################## Turn on minikube ###############################

if ! kubectl version 2>/dev/null 1>&2 ; then
#	service docker restart
	service nginx stop
	minikube start --driver=docker
	eval $(minikube docker-env)
	source ./funct.sh
fi

############################## Launched with arg ##############################

if [ "$1" = "fclean" ]; then
	kubectl delete all --all-namespaces --all
	exit
fi

############################## Install Metal LB ###############################

function install_metallb () {
	echo "Install MetalLB..."
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

kubectl apply -f ./srcs/metallb-configmap.yaml
}

if ! kubectl get pods -n metallb-system 2>&1 | grep controller | grep Running >/dev/null 2>&1; then
	install_metallb
	kubectl apply -f dashboard-adminuser.yaml
#	kubectl proxy &
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
fi

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
	printf "\tBuilding $service image...\n"
	docker build -t $service-img ./srcs/$service/
	kubectl delete -f srcs/$service-deployment.yaml #2>/dev/null 1>&2
	printf "\tCreating $service container...\n"
	kubectl apply -f ./srcs/$service-deployment.yaml # 1>/dev/null
	while ! kubectl get pods | grep $service | grep Running 1>/dev/null; do
		sleep 1;
	done
done
