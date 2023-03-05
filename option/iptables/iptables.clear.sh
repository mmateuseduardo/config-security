#!/bin/bash
#
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

### BEGIN INIT INFO
# Provides:          firewall
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
### END INIT INFO

/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -t nat -F
/sbin/iptables -t mangle -F
