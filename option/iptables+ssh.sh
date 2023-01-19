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

###BANNER
  printf "${Yellow}Instalação Simples e Configuração de IPTABLES C/ SSH para LINUX!!!\n"
  printf "${Green}\n Developed by: mmateuseduardo ( https://github.com/mmateuseduardo )"
  printf "${Green}\n Version: 1.8\n"

#Defina as portas que deseja proteger
#Config Security SSH

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
