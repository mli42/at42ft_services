if [ "$OSTYPE" != "linux-gnu" ] && [ "$MINIKUBE_ACTIVE_DOCKERD" != "minikube" ]; then
	eval $(minikube docker-env) &>/dev/null
fi

function kdeploy () {
	for service in "$@"
	do
		printf "\tBuilding \e[1;95m$service\e[0m image...\n"
		docker build -t $service-img ./srcs/$service/ >/dev/null
		printf "\tCreating \e[1;93m$service\e[0m container...\n"
		kubectl apply -f ./srcs/$service-deployment.yaml # 1>/dev/null
	done
}

function clean () {
	for service in "$@"
	do
		echo "\e[92mCleaning $service...\e[m"
		kubectl delete -f ./srcs/$service-deployment.yaml 2>/dev/null 1>&2
	done
}

function kre () {
	clean $@
	kdeploy $@
}

function fclean () { kubectl delete all --all-namespaces --all }

function watch_services () { watch kubectl get all --all-namespaces }

function get-token () {
	echo "\e[94mGet your token and go here :
	http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/\e[0m"

	if [ -n "$1" ]; then
		kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
	else
		secret_name=$(kubectl get secrets | grep dashboard-admin-sa | cut -d ' ' -f 1)
		kubectl describe secret $secret_name
	fi
	if  ! ps -a | grep -v grep | grep "kubectl proxy" &>/dev/null; then
		echo "\e[91mForgot to do a kubectl proxy ! 😡\e[m"
		kubectl proxy &;
	fi
	echo "\e[94mkubectl proxy enabled ! 👌\e[m"
}

function sshnginx () { rm -f ${HOME}/.ssh/known_hosts &&
	nginx_url=$(kubectl describe service/nginx-service | grep IPAllocated | cut -d "\"" -f 2) &&
	echo "\e[93mNo password needed 👀\e[0m" && ssh username@${nginx_url} -p 22
}

function dockexec () {
	service="$1";
	dockerfile_path=./srcs/$service/
	cmd="sh"
	if [ -n "$2" ]; then dockerfile_path="$2" fi
	if [ -n "$3" ]; then cmd="$3" fi
	docker build -t $service-img $dockerfile_path && \
	docker run --rm --name coucou -d -it $service-img && \
	docker exec -it coucou $cmd; docker kill coucou 2>/dev/null 1>&2
}

function install_depedencies () {
	if [ "$OSTYPE" != "linux-gnu" ]; then
		brew install watch lftp
	else
#		sudo apt-get install -y conntrack
		sudo apt-get install -y lftp
	fi
}

function kexec () {
	if [ -z "$1" ]; then echo "Give me a pod"; return 1; fi
	if [ -z "$2" ]; then 2="sh" ; fi
	1=$(echo $1 | cut -d '/' -f 2)
	kubectl exec -it $1 -- $2;
}

function klogs () {
	if [ -z "$1" ]; then echo "Give me a pod"; return 1; fi
	kubectl logs $1
}

function killdockersvc () {
	for service in "$@"
	do
		echo "\e[91mKilling $service...\e[m"
		docker kill $(docker ps | grep $service | grep -v "/pause" | cut -d ' ' -f 1)
	done
}
