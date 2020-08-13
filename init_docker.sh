#!/usr/bin/env bash
# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init_docker.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aguiot-- <aguiot--@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/18 08:17:08 by aguiot--          #+#    #+#              #
#    Updated: 2020/08/12 12:26:03 by mli              ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# https://github.com/alexandregv/42toolbox

# Ensure USER variabe is set
[ -z "${USER}" ] && export USER=$(whoami)

################################################################################

# Config
goinfre="/goinfre"
docker_destination="$goinfre/$USER/docker" #=> Select docker destination (goinfre is a good choice)
minikube_destination="$goinfre/$USER/minikube"

################################################################################

# Colors
blue=$'\033[0;34m'
cyan=$'\033[1;96m'
reset=$'\033[0;39m'
yellow=$'\e[0;1;93m'

# Uninstall docker, docker-compose and docker-machine if they are installed with brew
brew uninstall -f docker docker-compose docker-machine &>/dev/null ;:

# Check if APP is installed with MSC and open MSC if not
function mscinstall () {
if [ ! -d "/Applications/$1.app" ] && [ ! -d "~/Applications/$1.app" ]; then
	echo "${yellow}Please install ${cyan}$1${yellow} from the MSC (Managed Software Center)${reset}"
	open -a "Managed Software Center"
	read -n1 -p "${yellow}Press RETURN when you have successfully installed ${cyan}$1${yellow}...${reset}"
	echo ""
fi
}

mscinstall "Docker"
mscinstall "VirtualBox"

# Kill Docker if started, so it doesn't create files during the process
pkill Docker

# Ask to reset destination if it already exists
if [ -d "$docker_destination" ]; then
	read -n1 -p "${yellow}Folder ${cyan}$docker_destination${yellow} already exists, do you want to reset it? [y/${cyan}N${yellow}]${reset} " input
	echo ""
	if [ -n "$input" ] && [ "$input" = "y" ]; then
		rm -rf "$docker_destination"/{com.docker.{docker,helper},.docker} &>/dev/null ;:
	fi
fi

# Unlinks all symlinks, if they are
unlink ~/Library/Containers/com.docker.docker &>/dev/null ;:
unlink ~/Library/Containers/com.docker.helper &>/dev/null ;:
unlink ~/.docker &>/dev/null ;:
unlink ~/.minikube &>/dev/null ;:

# Delete directories if they were not symlinks
rm -rf ~/Library/Containers/com.docker.{docker,helper} ~/.docker &>/dev/null ;:
rm -rf ~/.minikube &>/dev/null ;:

# Create destination directories in case they don't already exist
mkdir -p "$docker_destination"/{com.docker.{docker,helper},.docker}
mkdir -p "$minikube_destination"/.minikube

# Make symlinks
ln -sf "$docker_destination"/com.docker.docker ~/Library/Containers/com.docker.docker
ln -sf "$docker_destination"/com.docker.helper ~/Library/Containers/com.docker.helper
ln -sf "$docker_destination"/.docker ~/.docker
ln -sf "$minikube_destination"/.minikube ~/.minikube

# Start Docker for Mac
open -g -a Docker

echo "${cyan}Docker${yellow} is now starting!${reset}" # "Please report any bug to: ${cyan}aguiot--${reset}"

read -n1 -p "${yellow}Press RETURN when ${cyan}Docker${yellow} is ready...${reset}"
echo ""
