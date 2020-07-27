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
