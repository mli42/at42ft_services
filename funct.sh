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
	echo "Get your token and go here :
	http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
	kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
	echo "Don't forget to do a kubectk proxy !"
}
