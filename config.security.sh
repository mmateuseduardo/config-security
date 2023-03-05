#!/bin/bash
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

  printf "${Yellow}Instalação Simples e Configuração de IPTABLES C/ SSH para LINUX!!!\n"
  printf "${Green}\n Developed by: mmateuseduardo ( https://github.com/mmateuseduardo )"
  printf "${Green}\n Version: 1.9\n"

######################
###MENU < TESTED OK###
######################
menu () {
        printf "\n${Yellow} [ Selecione uma Opção para Continuar ]\n\n"
        printf " ${Red}[${Blue}1${Red}] ${Green}Verifica Dependencias - Função Não Disponível\n"
        printf " ${Red}[${Blue}2${Red}] ${Green}Instalação do ZERO Iptables + Config SSH\n"
        printf " ${Red}[${Blue}3${Red}] ${Green}Instalação do ZERO Iptables + Config SSH + Liberação de Portas\n"
        printf " ${Red}[${Blue}4${Red}] ${Green}Resete Temporario das Configuração de IPTABLES\n"
        printf " ${Red}[${Blue}5${Red}] ${Green}Exit\n\n"
        printf "${Green}┌─[${Red}Selecione uma Opção${Green}]──[${Red}~${Green}]─[${Yellow}Menu${Green}]:\n"
        read -p "└──►$(tput setaf 7) " option
        case $option in
        1) Depedencia ;;
        2) Iptables+SSH ;;
        3) Iptables+SSH+Port ;;
        4) IptablesReset ;;
        5) Exit ;;
        *)printf "${White}[${Red}Error${White}] Selecione uma opção Correta...\n\n" ; menu ;;
esac
}
#######################################
###Instalação de Depedencia < TESTED###
#######################################
        Depedencia(){
        printf "\n[${Green}Selected${White}] Opção 1 - Verifica Dependencias - Função Não Disponível...\n\n"
        printf "${Red}\nFUNÇÃO NÃO DISPONÍVEL ${White}:)\n\n"
        menu
        }

##########################################
###Instalação Iptables+SSH < TESTED OK ###
##########################################
        Iptables+SSH(){
        printf "${Yellow}========================= Script de Instalação e Configuração Iptables SSH com LOG ============================\n"
        printf "${Yellow}============================================== Config SSH =====================================================\n"
        printf "${Green}┌─[${Red}Informe os Dados p/ o${Green}]──[${Red}~${Green}]─[${Yellow}Menu${Green}]:\n"
        printf "└──►$(tput setaf 7) "
        printf "${White}Digite o IP com permissão para SSH, Numero da Porta e o nome de Usuário com Permissão de Acesso\n"
        printf "${White}IP para o SSH: "
        read IPSSH4
        printf "${White}PORTA: "
        read PORTA
        printf "${White}USUÁRIO: "
        read USUARIO

        printf "${Red}\nStatus do SSH Antes de Reiniciar ${White}:)\n\n"
        systemctl status sshd.service
        mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bkp && cp ./option/ssh/banner /etc/ssh/banner &&
        cp ./option/ssh/sshd_config /etc/ssh/
        printf "${Red}\nStatus do SSH Após Reiniciar ${White}:)\n\n"
        sed -i "s/22/$PORTA/" /etc/ssh/sshd_config && sed -i "s/suporte/$USUARIO/" /etc/ssh/sshd_config
        systemctl restart sshd.service && systemctl status sshd.service


        printf "${Yellow}============================================ Config IPTABLES ====================================================="
        cp ./option/iptables/iptables.sh /etc/init.d/ && cp ./option/iptables/firewall.service /lib/systemd/system/
        chmod a+x  /etc/init.d/iptables.sh && chmod a+x /lib/systemd/system/firewall.service
        printf "${Red}\nRecarregando Daemon e Habilitando firewall.service (iptables) ${White}:)\n\n"
        systemctl daemon-reload
        systemctl enable firewall
        systemctl list-unit-files | grep firewall

        sed -i "s/22/$PORTA/" /etc/init.d/iptables.sh && sed -i "s/SSH/$IPSSH4/" /etc/init.d/iptables.sh

        printf "${Red}\nIniciando Serviço de IPTABLES ${White}:)\n\n"
        systemctl start firewall.service &&  /etc/init.d/iptables.sh status
        printf "${Red}\nCONFIGURAÇÃO APLICADAS COM SUCESSO - NECESSÁRIO RECONECTAR!!! ${White}:)\n\n"
        menu
        }

##############################################
###Instalação Iptables+SSH+Port < TESTED OK###
##############################################
        Iptables+SSH+Port(){
		printf "\n[${Green}Selected${White}] Opção 3 - Instalação do ZERO Iptables + Config SSH + Liberação de Portas...\n\n"
        /bin/bash ./option/iptables+ssh+port.sh
        }

###########################################
###Instalação Iptables+Reset < TESTED OK###
###########################################
        IptablesReset(){
        printf "\n[${Green}Selected${White}] Opção 4 - Resete Temporario das Configuração de IPTABLES...\n"
        printf "${Yellow}========================= Script de RESET de Configuração Iptables SSH com LOG ================================\n"
        printf "${Red}\nStatus do IPTABLES Antes do Resete Temporario ${White}:)\n\n"
        /sbin/iptables -L
        printf "${Red}\nStatus do IPTABLES Resetado de Forma Temporaria ${White}:)\n\n"
        /sbin/iptables -F
        /sbin/iptables -X
        /sbin/iptables -t nat -F
        /sbin/iptables -X -t nat
        /sbin/iptables -F -t mangle
        /sbin/iptables -X -t mangle
        /sbin/iptables -P OUTPUT ACCEPT
        /sbin/iptables -P FORWARD ACCEPT
        /sbin/iptables -P INPUT ACCEPT

        /sbin/ip6tables -F
        /sbin/ip6tables -X
        /sbin/ip6tables -F -t mangle
        /sbin/ip6tables -X -t mangle

        /sbin/modprobe ip_conntrack_ftp
        /sbin/modprobe ip_nat_ftp
        /sbin/modprobe ipt_state
        /sbin/modprobe ipt_limit
        /sbin/modprobe ipt_MASQUERADE
        /sbin/modprobe ipt_LOG
        /sbin/modprobe iptable_nat
        /sbin/modprobe iptable_filter
        /sbin/modprobe ip_gre
        /sbin/iptables -L
        menu
        }

#######################
###Exit < TESTED OK####
#######################
        Exit (){
        printf "${Red}\nObrigado por usar o Scirpt ${White}:)\n\n"
        exit 0
}
menu
