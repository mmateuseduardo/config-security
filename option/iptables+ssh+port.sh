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

##### Banner #####
  printf "${Yellow}Instalação Simples e Configuração de IPTABLES C/ SSH para LINUX!!!\n"
  printf "${Green}\n Developed by: mmateuseduardo ( https://github.com/mmateuseduardo )"
  printf "${Green}\n Version: 1.8\n"

#Defina as portas que deseja proteger
#Config Security SSH

printf "${Yellow}========================= Script de Instalação e Configuração Iptables SSH com LOG ============================\n"
printf "${Yellow}============================================== Config SSH =====================================================\n"
  printf "${Green}┌─[${Red}Informe os Dados p/ o${Green}]──[${Red}~${Green}]─[${Yellow}Menu${Green}]:\n"
  printf "└──► "
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
     cp -r ./option/lport /etc/init.d/

##### MENU IPTABLES #####
function menu() {
printf "${Yellow}============================================ Config IPTABLES =====================================================\n"

       cp ./option/iptables/iptables+port.sh /etc/init.d/iptables.sh && cp ./option/iptables/firewall.service /lib/systemd/system/
       chmod a+x  /etc/init.d/iptables.sh && chmod a+x /lib/systemd/system/firewall.service
       printf "${Red}\nRecarregando Daemon e Habilitando firewall.service - Firewall C/ SSH - JÁ CONFIGURADO (iptables) ${White}:)\n\n"
       systemctl daemon-reload
       systemctl enable firewall
       systemctl list-unit-files | grep firewall

       sed -i "s/22/$PORTA/" /etc/init.d/iptables.sh && sed -i "s/SSH/$IPSSH4/" /etc/init.d/iptables.sh

  printf "\n${Yellow} [ Selecione o protocolo que vai utilizar ]\n\n"
  printf " ${Red}[${Blue}1${Red}] ${Green}TCP\n"
  printf " ${Red}[${Blue}2${Red}] ${Green}UDP\n"
  printf " ${Red}[${Blue}3${Red}] ${Green}TCP/UDP\n"
  printf " ${Red}[${Blue}4${Red}] ${Green}Alterar / Remover -  Função Não Disponível\n"
  printf " ${Red}[${Blue}5${Red}] ${Green}Reiniciar IPTABLES - Vai Ser Necessário Reconectar\n"
  printf " ${Red}[${Blue}6${Red}] ${Green}Voltar ao Menu Anterior\n"
  printf " ${Red}[${Blue}7${Red}] ${Green}Reset de Configuração SSH\n"
  printf " ${Red}[${Blue}8${Red}] ${Green}Exit\n"
  while true; do
  printf "${Green}┌─[${Red}Select Option${Green}]──[${Red}~${Green}]─[${Yellow}Menu${Green}]:\n"
  read -p "└──► " option
  case $option in
##### LIBERAR PORTA TCP < OK TESTED
    1) printf "\n[${Green}Selected${White}] Opção 1 - TCP...\n"
       printf "\n${White}Digite as Portas Separada por Espaço"
       printf "\n${White}Porta TCP: "
       read  TCP
       echo $TCP > /etc/init.d/lport/ltcp.txt &&
       tr -s '[:space:]' '\n' < /etc/init.d/lport/ltcp.txt >> /etc/init.d/lport/tcp.txt
       menu
       ;;
##### LIBERAR PORTA UDP < OK TESTED
    2) printf "\n[${Green}Selected${White}] Opção 2 - UDP...\n"
       printf "\n${White}Digite as Portas Separada por Espaço"
       printf "\n${White}Porta UDP: "
       read  UDP
       echo $UDP > /etc/init.d/lport/ludp.txt &&
       tr -s '[:space:]' '\n' < /etc/init.d/lport/ludp.txt >> /etc/init.d/lport/udp.txt
       menu

       ;;
##### LIBERAR PORTA TCP UDP < OK TESTED
    3) printf "\n[${Green}Selected${White}] Opção 3 - TCP/UDP...\n"
       printf "\n${White}Digite as Portas Separada por Espaço"
       printf "\n${White}Porta TCP/UDP: "
       read PORTAL
       echo $PORTAL > /etc/init.d/lport/llport.txt &&
       tr -s '[:space:]' '\n' < /etc/init.d/lport/llport.txt >> /option/lport/lport.txt
       menu

;;
#### ALTERAR REMOVER
    4) printf "\n[${Green}Selected${White}] Opção 4 - Alterar / Remover - Função Não Disponível...\n"
       printf "${Red}\nFUNÇÃO NÃO DISPONÍVEL ${White}:)\n\n"
       menu
     ;;
#### REINICIAR IPTABLES
    5) printf "\n[${Green}Selected${White}] Opção 5 - Reiniciar IPTABLES - Vai Ser Necessário Reconectar...\n"
       printf "${Red}\nReiniciando Serviço de SSH ${White}:)\n\n"
       systemctl restart sshd.service && systemctl status sshd.service
       printf "${Red}\nIniciando Serviço de IPTABLES ${White}:)\n\n"
       systemctl start firewall.service &&  /etc/init.d/iptables.sh status
       printf "${Red}\nCONFIGURAÇÃO APLICADAS COM SUCESSO - NECESSÁRIO RECONECTAR!!! ${White}:)\n\n"
       menu
    ;;
##### LIBERAR VOLTAR AO MENU ANTERIOR < OK TESTED
    6)  printf "\n[${Green}Selected${White}] Opção 6 - Voltar ao Menu Anterior...\n"
       ./config.security.sh
##### RESET DE CONFIGURAÇÃO < OK TESTED
       ;;
    7)  printf "\n[${Green}Selected${White}] Opção 7 - Reset de Configuração SSH...\n"
    printf "${Red}\nStatus do SSH Antes de Resetar ${White}:)\n\n"
    systemctl status sshd.service &
    mv /etc/ssh/sshd_config.bkp /etc/ssh/sshd_config &
    printf "${Red}\nStatus Serviço Resetado e Reiniciado ${White}:)\n\n"
    systemctl restart sshd.service && systemctl status sshd.service
    menu
      ;;
##### EXIT < OK TESTED
    8) printf "${Red}\nObrigado por usar o Script ${White}:)\n\n"
       exit 0

       ;;
   *) printf "${White}[${Red}Error${White}]Por favor, selecione uma opção...\n\n"
       ;;
  esac
  done
}
function menuiptables() {
  menu
}
menuiptables
