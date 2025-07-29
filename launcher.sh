#!/bin/bash

# Colors
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

# Root
if [ $UID -ne 0 ]; then
	echo -e "${redColor}[!] Permission denied${endColor}"
	exit 1
fi

# Only debian
if [ ! -f /etc/debian_version ]; then
	echo -e "${redColor}[!] script only for debian${endColor}"
	echo -e "${redColor}[!] exit${endColor}"
	exit 1
fi

# Dependencies
echo -e "${greenColor}[?] Do you want update and install dependencies? [Y/n]"
read dependencies
if [ -z $dependencies ] || [[ $dependencies =~ ^[nN] ]]; then
	echo -e "${redColor}[!] exit...${endColor}"
else
	echo -e "[?] Your system is Ubuntu or Debian? [1/2]"
	read SO
	if [[ "$SO" -eq 1 ]]; then
		for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg &>/dev/null; done &>/dev/null
		apt-get update &>/dev/null
		apt-get install ca-certificates curl -y &>/dev/null
		install -m 0755 -d /etc/apt/keyrings &>/dev/null
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &>/dev/null
		chmod a+r /etc/apt/keyrings/docker.asc &>/dev/null
		echo \
  			"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  			$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
		tee /etc/apt/sources.list.d/docker.list > /dev/null
		apt-get update &>/dev/null
		apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &>/dev/null
	elif [[ "$SO" -eq 2 ]]; then
		apt update &>/dev/null
		for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg &>/dev/null; done &>/dev/null
		apt-get update &>/dev/null
		apt-get install ca-certificates curl -y &>/dev/null
		install -m 0755 -d /etc/apt/keyrings &>/dev/null
		curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc &>/dev/null
		chmod a+r /etc/apt/keyrings/docker.asc &>/dev/null
		echo \
  			"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  			$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  		tee /etc/apt/sources.list.d/docker.list > /dev/null
		apt-get update &>/dev/null
		apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &>/dev/null
	else
		echo -e "${redColor}[!] What is your SO?${endColor}"
		exit 1
	fi
	if ! command -v docker &>/dev/null; then
		echo -e "${redColor}[!] An error with docker occurred"
		exit 1
	else
		echo -e "${blueColor}[+] All installed${endColour}"
	fi
fi