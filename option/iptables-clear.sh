#!/usr/bin/env bash
#
# ============================================================================ #
# CONFIG IPTABLES.                                                             #
# config.security.sh                                                           #
# Autor: mmateuseduardo                                                        #
# URL: https://github.com/mmateuseduardo                                       #
# ============================================================================ #
# CREDITOS                                                                     #
# Colaborador: danielcshn remontti                                             #
# URL: https://github.com/danielcshn URL:https://github.com/remontti           #
# ============================================================================ #
# Todo projeto foi desenvolvido por mim, mas algumas ideias e scripts          #
# que estão no meio do código pertence a outras pesssoas, sendo assim não      #
# seria certo deixar de comentar o nome delas e dar os creditos,               #
# Muito Obrigado e espero futuramente fazer melhorias                          #
# ============================================================================ #
# Copyright (c) 2023 mmateuseduardo                                            #
# ============================================================================ #
# Este script vem com ABSOLUTAMENTE NENHUMA GARANTIA!                          #
# This Script comes with ABSOLUTELY NO WARRANTY!                               #
#
# High Intensty Colors Used:                                                   #
# https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124#file-bash-colors-md #
# =============================================================================#

Black="\e[0;90m"
Red="\e[1;31m" # Bold
Green="\e[0;92m"
Yellow="\e[0;93m"
Blue="\e[0;94m"
Purple="\e[0;95m"
Cyan="\e[0;96m"
White="\e[0;97m"

#LIMPANDO REGRAS DE IPTABLES E SSH

printf "${Yellow}========================= Script de RESET de Configuração Iptables SSH com LOG ================================\n"
printf "${Yellow}============================================== Config SSH======================================================\n"
systemctl status sshd.service
     cp /etc/ssh/sshd_config.bkp  /etc/ssh/sshd_config && rm /etc/ssh/banner
systemctl restart sshd.service && systemctl status sshd.service

printf "${Yellow}============================================ Config IPTABLES ====================================================="
    cp ./option/iptables/iptables.sh /etc/init.d/ && cp ./option/iptables/firewall.service /lib/systemd/system/
    chmod a+x  /etc/init.d/iptables.sh && chmod a+x /lib/systemd/system/firewall.service
systemctl daemon-reload
systemctl disable firewall
systemctl list-unit-files | grep firewall

systemctl restart sshd.service && systemctl status sshd.service
/etc/init.d/iptables.sh status 

function banner() {
  printf "${Yellow}\n\n Instalação Simples e Configuração de IPTABLES C/ SSH para LINUX!!!\n"
  printf "${Green}\n Developed by: mmateuseduardo ( https://github.com/mmateuseduardo )"
  printf "${Green}\n Version: 1.5\n"
}
##### Display available options #####
function menu() {
  printf "\n${Yellow} [ Select Option To Continue ]\n\n"
  printf " ${Red}[${Blue}1${Red}] ${Green}Verifica Dependencias\n"
  printf " ${Red}[${Blue}2${Red}] ${Green}Instalação do ZERO Iptables + Config SSH\n"
  printf " ${Red}[${Blue}3${Red}] ${Green}Instalação do ZERO Iptables + Config SSH + Liberação de Portas\n"
  printf " ${Red}[${Blue}4${Red}] ${Green}Apagar configuração já existente\n"
  printf " ${Red}[${Blue}5${Red}] ${Green}Exit\n\n"
  while true; do
  printf "${Green}┌─[${Red}Select Option${Green}]──[${Red}~${Green}]─[${Yellow}Menu${Green}]:\n"
  read -p "└──►$(tput setaf 7) " option
  case $option in
    1) printf "\n[${Green}Selected${White}] Option 1 Check Dependencies...\n\n"
       checkDependencies
       ;;
    2) printf "\n[${Green}Selected${White}] Option 2 Instalação do ZERO Iptables + Config SSH...\n"
        /bin/bash ./option/iptables+ssh.sh
       ;;
    3) printf "\n[${Green}Selected${White}] Option 3 Launch The Dude Client...\n\n"
       launchDude
       ;;
    5) printf "${Red}\nObrigado por usar o Script ${White}:)\n\n"
       exit 0
       ;;
    *) printf "${White}[${Red}Error${White}] Por favor, selecione uma opção...\n\n"
       ;;
  esac
  done
}
function config.security () {
  clear
  banner
  menu
}
config.security
