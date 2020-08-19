#!/usr/bin/env zsh

############################## Turn on minikube ###############################

if  [ "$OSTYPE" = "linux-gnu" ] && ! groups | grep "docker" 2>/dev/null 1>&2; then
	echo "Please do : sudo usermod -aG docker user42; newgrp docker"
	exit
fi

if ! kubectl version 2>/dev/null 1>&2 ; then
	if [ "$OSTYPE" = "linux-gnu" ]; then
#		service docker restart
		service nginx stop
		sudo minikube start --driver=none || { echo "try 'sudo chown -R user42 $HOME/.kube $HOME/.minikube' and then... good luck" && exit }
		sudo chown -R user42 $HOME/.kube $HOME/.minikube
		echo "\e[91mYou'll need to do 'sudo minikube stop' when finished\e[0m"
	else
		##### On MacOS
		if [ -d /goinfre ]; then
			./init_docker.sh # Only if at school 42
		else
			open -g -a Docker && sleep 5
		fi
		# Install BREW 🍺
		if ! which brew &>/dev/null; then
			echo "\t\t\e[1;93mInstall BREW 🍺...\e[0m"
			rm -rf $HOME/.brew && git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew && echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc && source $HOME/.zshrc && brew update
		fi
		# Install minikube && kubectl
		if ! which minikube &>/dev/null; then
			echo "\t\t\e[1;93mInstall minikube and kubectl 🐳...\e[0m"
			brew install minikube
		fi
		minikube start --driver=virtualbox || { echo "Couldn't start, try minikube delete"; exit }
	fi
fi

if [ "$OSTYPE" != "linux-gnu" ]; then
	eval $(minikube docker-env)
fi

############################## Install Metal LB ###############################

function install_metallb () {
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
	echo "\t\t\e[1;93mInstall MetalLB...\e[0m"
	install_metallb > /dev/null
	kubectl apply -f ./srcs/dashboard-adminuser.yaml
	kubectl proxy 2>/dev/null &
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml

	kubectl create serviceaccount dashboard-admin-sa &>/dev/null
	kubectl create clusterrolebinding dashboard-admin-sa \
		--clusterrole=cluster-admin \
		--serviceaccount=default:dashboard-admin-sa &>/dev/null
fi

###############################################################################
source ./funct.sh

red="\e[1;91m"
green="\e[1;92m"
yellow="\e[1;93m"
dblue="\e[1;94m"
purple="\e[1;95m"
blue="\e[1;96m"
eoc="\e[0m"
underlined="\e[4m"

DB_NAME=wordpress; DB_USER=wpuser; DB_PASSWORD=password; DB_HOST=mysql;

services=(		\
	nginx		\
	ftps		\
	wordpress	\
	mysql		\
	phpmyadmin	\
	grafana		\
	influxdb	\
)

kubectl delete secret/db-id 2>/dev/null 1>&2
kubectl delete secret/mliuser 2>/dev/null 1>&2
clean $services

echo "\e[97mBuilding \e[1;93mft_services\e[97m:\e[0m"

printf "\tBuilding \e[1;95mcommon\e[0m image...\n"
docker build -t ft_services ./srcs/base-img/ >/dev/null

kubectl create secret generic db-id \
	--from-literal=name=${DB_NAME} \
	--from-literal=user=${DB_USER} \
	--from-literal=password=${DB_PASSWORD} \
	--from-literal=host=${DB_HOST}

kubectl create secret generic mliuser \
	--from-literal=user="mliuser" \
	--from-literal=password="mlipass" \

for service in "${services[@]}"
do
	kdeploy $service
	while ! kubectl get pods | grep $service | grep Running 1>/dev/null 2>&1 ; do
		sleep 1;
	done
done

echo "\t${green}ft_services is ready${eoc}:"
echo "${yellow}${underlined}Dashboard${eoc}: ${dblue}'source ./funct.sh && get-token'${eoc}"
echo "${yellow}${underlined}PhpMyAdmin/MySQL${eoc}: ${dblue}${DB_USER}:${DB_PASSWORD}${eoc}"
echo "${yellow}${underlined}wpUsers${eoc}: ${dblue}admin:admin (admin) | wpuser1:wpuser1pass (author) | wpuser2:wpuser2pass (subscriber)${eoc}"

echo "${yellow}${underlined}ftps${eoc}:"
ftps_ip=$(kubectl get services ftps --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "${purple}- ${dblue}lftp -u 42user,42pass $ftps_ip -p 21 -e \"set ssl:verify-certificate false\"${eoc}" # debug 999 for verbose
echo "${green}OR${eoc}"
echo "${purple}- ${dblue}curl --ftp-ssl --insecure --user 42user:42pass ftp://${ftps_ip}:21${eoc}" # -v for verbose
echo "${yellow}${underlined}Grafana${eoc}: ${dblue}mliuser:mlipass${eoc}"
