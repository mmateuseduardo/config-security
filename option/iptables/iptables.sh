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
#!/bin/bash
### BEGIN INIT INFO
# Provides:          firewall
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
### END INIT INFO
 
#Defina as portas que deseja proteger
PORTAS="22"
#Defina os IPv4s que terão acesso a estas portas
IP4GERENCIA="SSH"
#Defina os IPv4s que terão acesso a estas portas
IP6GERENCIA="::1;"
 
# Não altere as linhas abaixo
VERMELHO='\033[1;31m'
VERDE='\033[1;32m'
AZUL='\033[1;36m'
AMARELO='\033[1;33m'
ROSA='\033[1;35m'
NC='\033[0m'
 
function startFirewall(){
    /sbin/iptables -F
    /sbin/iptables -X
    /sbin/iptables -t nat -F
    /sbin/iptables -X -t nat
    /sbin/iptables -F -t mangle
    /sbin/iptables -X -t mangle
    /sbin/iptables –P INPUT DROP
    /sbin/iptables –P FORWARD DROP
    /sbin/iptables -P OUTPUT ACCEPT

    /sbin/ip6tables -F
    /sbin/ip6tables -X
    /sbin/ip6tables -F -t mangle
    /sbin/ip6tables -X -t mangle
    /sbin/ip6tables -P INPUT DROP
    /sbin/ip6tables -P FORWARD DROP
    /sbin/ip6tables -P OUTPUT ACCEPT

    /sbin/modprobe ip_conntrack_ftp
    /sbin/modprobe ip_nat_ftp
    /sbin/modprobe ipt_state
    /sbin/modprobe ipt_limit
    /sbin/modprobe ipt_MASQUERADE
    /sbin/modprobe ipt_LOG
    /sbin/modprobe iptable_nat
    /sbin/modprobe iptable_filter
    /sbin/modprobe ip_gre

# Bloqueia qualquer INPUT que não esteja definido nessa lista.
/sbin/iptables -P INPUT DROP

# Permitir conexões TCP/UDP para fora. Mantenha o estado para que os pacotes de saida sejam permitidos de volta
/sbin/iptables -A INPUT  -p tcp -m state --state ESTABLISHED     -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
/sbin/iptables -A INPUT  -p udp -m state --state ESTABLISHED     -j ACCEPT
/sbin/iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT

/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT # libera pacotes sincronizados
/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT # Libera acesso via Loopback
/sbin/iptables -A INPUT -i lo -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT # Libera acesso via Loopback
/sbin/iptables -A OUTPUT -o lo -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT # Libera acesso via Loopback

/sbin/iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP # descartar qualquer pacote tcp que não inicie uma conexão com um sinalizador syn.
/sbin/iptables -A INPUT -m state --state INVALID -j DROP # Descarte qualquer pacote inválido que não pôde ser identificado

# Descarte pacotes inválidos
/sbin/iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
/sbin/iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN              -j DROP
/sbin/iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST              -j DROP
/sbin/iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,RST FIN,RST              -j DROP
/sbin/iptables -A INPUT -p tcp -m tcp --tcp-flags ACK,FIN FIN                  -j DROP
/sbin/iptables -A INPUT -p tcp -m tcp --tcp-flags ACK,URG URG                  -j DROP

#Para proteger contra ataques de inundação de ping
/sbin/iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 60/minute --limit-burst 120 -j ACCEPT
/sbin/iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/minute --limit-burst 2 -j LOG
/sbin/iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
#

/sbin/iptables -A INPUT -f -j DROP # bloqueia pacotes fragmentados
/sbin/iptables -A INPUT -f -j LOG --log-prefix "Pacote INPUT fragmentado: " # gera log de pacotes fragmentados

    #Protege portas IPv4
    echo; echo -e "[${ROSA} Regras IPv4 ${NC}]"; echo
    portas=$(echo $PORTAS | tr ";" "\n")
    for porta in $portas
    do
        ip4s=$(echo $IP4GERENCIA | tr ";" "\n")
        for ip4 in $ip4s
        do
            /sbin/iptables -A INPUT -s $ip4 -p tcp --dport $porta -j ACCEPT
	    /sbin/iptables -A INPUT -p tcp --dport $porta -j LOG --log-prefix "LOG TCP DA PORTA PROTEGIDA \ "

            echo -e "[${VERDE} ok ${NC}] Porta ${AMARELO}[$porta]${NC} aberta para ${AZUL}$ip4${NC}"
            sleep 0.1
        done
    done
    portas=$(echo $PORTAS | tr ";" "\n")
    for porta in $portas
    do
        /sbin/iptables -A INPUT -p tcp --dport $porta -j DROP
        echo -e "[${VERDE} ok ${NC}] Porta ${VERMELHO}[$porta]${NC} fechada"
        sleep 0.1
    done
    #Protege portas IPv6
    echo; echo -e "[${ROSA} Regras IPv6 ${NC}]"; echo
 
    portas=$(echo $PORTAS | tr ";" "\n")
    for porta in $portas
    do
        ip6s=$(echo $IP6GERENCIA | tr ";" "\n")
        for ip6 in $ip6s
        do
            /sbin/ip6tables -A INPUT -s $ip6 -p tcp --dport $porta -j ACCEPT
            /sbin/ip6tables -A INPUT -s $ip6 -p udp --dport $porta -j ACCEPT
            echo -e "[${VERDE} ok ${NC}] Porta ${AMARELO}[$porta]${NC} aberta para ${AZUL}$ip6${NC}"
        done
    done
    portas=$(echo $PORTAS | tr ";" "\n")
    for porta in $portas
    do
        /sbin/ip6tables -A INPUT -p tcp --dport $porta -j DROP
        echo -e "[${VERDE} ok ${NC}] Porta ${VERMELHO}[$porta]${NC} fechada"
        sleep 0.1
    done
}
 
function stopFirewall(){
    /sbin/iptables -F
    /sbin/iptables -X
    /sbin/iptables -t nat -F
    /sbin/iptables -X -t nat
    /sbin/iptables -F -t mangle
    /sbin/iptables -X -t mangle
 
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
}
 
case "$1" in
    start )
        startFirewall
        echo; echo -e "[${VERDE} Firewall carregado ${NC}]"; 
        echo "Use: /etc/init.d/rr-firewall status"
        echo "para verificar as regras"
        ;;
 
    stop )
        stopFirewall
        echo; echo -e "[${VERDE} Regras de firewall removidas ${NC}]"; echo
        ;;
 
    restart )
        stopFirewall
        sleep 1
        startFirewall
        ;;
 
    status )
        echo; echo -e "[${VERDE} Regras IPv4 ${NC}]"; echo
        /sbin/iptables -nL
        echo; echo -e "[${VERDE} Regras IPv6 ${NC}]"; echo
        /sbin/ip6tables -nL
        ;;
 
    * )
        echo "Opção inválida, use rr-firewall start | stop | restart | status"
        ;;
esac
