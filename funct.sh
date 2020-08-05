function clean () {
	for service in "$@"
	do
		echo "\e[92mCleaning $service...\e[m"
		kubectl delete -f ./srcs/$service-deployment.yaml 2>/dev/null 1>&2
	done
}

function fclean () { kubectl delete all --all-namespaces --all }

function watch_services () { watch kubectl get all --all-namespaces }

function get-token () {
	echo "\e[94mGet your token and go here :
	http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/\e[0m"

	if [ -n "$1" ]; then
		kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
	else
		kubectl create serviceaccount dashboard-admin-sa 2>/dev/null 1>&2
		kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa 2>/dev/null 1>&2
		secret_name=$(kubectl get secrets | grep dashboard-admin-sa | cut -d ' ' -f 1)
		kubectl describe secret $secret_name
	fi
	echo "\e[94mDon't forget to do a kubectk proxy !\e[m"
}

function sshnginx () { rm -f ${HOME}/.ssh/known_hosts &&
	nginx_url=$(kubectl get services | grep nginx | cut -d " " -f 10) &&
	echo "\e[93mNo password needed 👀\e[0m" && ssh username@${nginx_url} }

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
	sudo apt-get install -y conntrack
	sudo apt-get install -y lftp
}

function kexec () {
	if [ -z "$1" ]; then echo "Give me a pod"; return 1; fi
	if [ -z "$2" ]; then 2="sh" ; fi
	kubectl exec -it $1 -- $2;
}
