#!/bin/sh
# /root/bin/fw.`hostname`
#############################################################
# MANAGED BY PUPPET. DO NOT EDIT. CHANGES WILL BE WIPED OUT #
#############################################################
#
# Iptables rules for a puppet master server and developer desktop (carbon)
#
# Copyright (C) (2012-13) K-B.Kronlund <bkronmailbox-copyright@yahoo.se>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
## Basic data

IPTABLES=/sbin/iptables
MODPROBE=/sbin/modprobe

IPTSAVE=/sbin/iptables-save
IPTSAVEFILE=/root/bin/IPTABLES.FW

NET_INT="192.168.0.0/24"
IF_INT=eth0

NTPHOSTADDR="192.168.0.1"
FILESERVERADDR="192.168.2.83"
INTMINECRAFTADDR="192.168.1.12"
EXTMINECRAFTADDR="217.70.39.231"

NFSHOSTADDR="192.168.0.10"

# Printers for desktops
NETPRN_HP3015_ADDR="192.168.0.30"
MDNSMULTICASTADDR="224.0.0.251"

## Log options
LOGOPT="LOG --log-level emerg --log-ip-options --log-tcp-options"

## Prevent excessive logging
RLIMIT="-m limit --limit 3/s --limit-burst 8"

## Load modules

$MODPROBE ip_conntrack
$MODPROBE ip_conntrack_ftp

## Flush old rules, old custom rules

$IPTABLES -F
$IPTABLES -X

## Default policies

$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP

## Free reign to loopback interfaces
$IPTABLES -I INPUT 1 -i lo -j ACCEPT
$IPTABLES -I OUTPUT 1 -o lo -j ACCEPT

## Prevent invalid input packages
$IPTABLES -A INPUT -m state --state INVALID -j $LOGOPT $RLIMIT --log-prefix "DROP INPUT INVALID "
$IPTABLES -A INPUT -m state --state INVALID -j DROP


## ======================
## ALLOW INBOUND TRAFFIC
## ======================

#-----------------------------------------------------------
# Internal inbound traffic (from internal net --> this host)
#
# destination (-d ) is not required since rules are always
# used in INPUT chain and thus implicitely gives this host.
#-----------------------------------------------------------

# allow all established and related in
$IPTABLES -A INPUT -p all -s $NET_INT -m state --state ESTABLISHED,RELATED -j ACCEPT

# multicast mDNS packets from internal printers to this host.
$IPTABLES -A INPUT -p udp -s $NET_INT -m udp --dport 5353 -j ACCEPT

# allow pings from internal net to this host
$IPTABLES -A INPUT -p icmp --icmp-type echo-reply -s $NET_INT -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type echo-request -s $NET_INT -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type destination-unreachable -s $NET_INT -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type time-exceeded -s $NET_INT -j ACCEPT

# allow ssh from our internal LAN
$IPTABLES -A INPUT -p tcp -s $NET_INT -m tcp --dport 22 -m state --state NEW -j ACCEPT

# allow cups network printer packets
$IPTABLES -A INPUT -p tcp -s $NET_INT -m tcp --dport 631 -m state --state NEW -j ACCEPT

# ntp time information (udp) from our internal LAN NTP server
$IPTABLES -A INPUT -p udp -s $NET_INT -m udp --dport 123 -m state --state NEW -j ACCEPT

# puppet client requests to this master server
$IPTABLES -A INPUT -p tcp -s $NET_INT -m tcp --dport 8140 -m state --state NEW -j ACCEPT

$IPTABLES -A INPUT -d 192.168.0.24 -s $NFSHOSTADDR -p udp --dport 111 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -d 192.168.0.24 -s $NFSHOSTADDR -p udp --dport 2049 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -d 192.168.0.24 -s $NFSHOSTADDR -p udp --dport 4000:4001 -m state --state NEW -j ACCEPT

## TCP

$IPTABLES -A INPUT -d 192.168.0.24 -s $NFSHOSTADDR -p tcp --dport 111 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -d 192.168.0.24 -s $NFSHOSTADDR -p tcp --dport 2049 -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -d 192.168.0.24 -s $NFSHOSTADDR -p tcp --dport 4000:4001 -m state --state NEW -j ACCEPT

#-------------------------------------------------------------------------
# Potential external inbound traffic (from external net --> this host)
#
# destination (-d ) is not required since rules are always
# used in INPUT chain and thus implicitely gives this host.
#-------------------------------------------------------------------------

$IPTABLES -A INPUT -p all ! -s $NET_INT -m state --state ESTABLISHED,RELATED -j ACCEPT

## Note: Dangerous (do not add any '-m state NEW -j ACCEPT' here without a careful pause!)

#---------------------------------------------------------------------------
# CATCH ALL INPUT LOG-and-DROP RULES (you may be suprised what ends up here)
#---------------------------------------------------------------------------

$IPTABLES -A INPUT ! -i lo -j $LOGOPT $RLIMIT --log-prefix "DROP INPUT DEFAULT "
$IPTABLES -A INPUT ! -i lo -j DROP


## =======================
## ALLOW OUTBOUND TRAFFIC
## =======================

#-----------------------------------------------------------
# Internal outbound traffic (from this host--> external net)
#-----------------------------------------------------------

# allow all established and related out to external net
$IPTABLES -A OUTPUT -p all ! -d $NET_INT -m state --state ESTABLISHED,RELATED -j ACCEPT

## allow ssh out to connect to our minecraft servers (local minecraft & levonline VPS)
$IPTABLES -A OUTPUT -p tcp -d $INTMINECRAFTADDR -m tcp --dport 22 -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp -d $EXTMINECRAFTADDR -m tcp --dport 22 -m state --state NEW -j ACCEPT

# allow dns (udp/tcp) queries out
$IPTABLES -A OUTPUT -p tcp ! -d $NET_INT -m tcp --dport 53 -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p udp ! -d $NET_INT -m udp --dport 53 -m state --state NEW -j ACCEPT

# allow web traffic out
$IPTABLES -A OUTPUT -p tcp ! -d $NET_INT -m tcp --dport 80 -m state --state NEW -j ACCEPT

# allow https out
$IPTABLES -A OUTPUT -p tcp ! -d $NET_INT -m tcp --dport 443 -m state --state NEW -j ACCEPT

# allow git protocol out (to GitHub)
$IPTABLES -A OUTPUT -p tcp ! -d $NET_INT -m tcp --dport 9418 -m state --state NEW -j ACCEPT


#------------------------------------------------------------
# Internal outbound traffic (from this host --> internal net)
#------------------------------------------------------------

# allow all established and related out to internal net
$IPTABLES -A OUTPUT -p all -d $NET_INT -m state --state ESTABLISHED,RELATED -j ACCEPT

## allow ssh to connect to our internal ssh servers (valhall & warp)
$IPTABLES -A OUTPUT -p tcp -d $NET_INT -m tcp --dport 22 -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp -d $FILESERVERADDR -m tcp --dport 22 -m state --state NEW -j ACCEPT

## allow smtp to connect to our internal mail (smtp) server
$IPTABLES -A OUTPUT -p tcp -d $NET_INT -m tcp --dport 25 -m state --state NEW -j ACCEPT

# udp is stateless but iptables keeps track of udp 'states'
$IPTABLES -A OUTPUT -p udp -d $NTPHOSTADDR -m udp --dport 123 -m state --state NEW -j ACCEPT

# imap clients use this port to contact the imap mail server
$IPTABLES -A OUTPUT -p tcp -d $NET_INT -m tcp --dport 143 -m state --state NEW -j ACCEPT

# allow rsyslog out to internal file server (i.e. log server)
$IPTABLES -A OUTPUT -p tcp -d $FILESERVERADDR -m tcp --dport 514 -m state --state NEW -j ACCEPT

# imaps secure clients (internal users) access their mailboxes to this mail server on this port
$IPTABLES -A OUTPUT -p tcp -d $NET_INT -m tcp --dport 993 -m state --state NEW -j ACCEPT

## NFS client (consume exported file system)
## UDP
$IPTABLES -A OUTPUT -s 192.168.0.24 -d $NFSHOSTADDR -p udp --dport 111 -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -s 192.168.0.24 -d $NFSHOSTADDR -p udp --dport 2049 -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -s 192.168.0.24 -d $NFSHOSTADDR -p udp --dport 4000:4001 -m state --state NEW -j ACCEPT

## TCP
$IPTABLES -A OUTPUT -s 192.168.0.24 -d $NFSHOSTADDR -p tcp --dport 111 -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -s 192.168.0.24 -d $NFSHOSTADDR -p tcp --dport 2049 -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -s 192.168.0.24 -d $NFSHOSTADDR -p tcp --dport 4000:4001 -m state --state NEW -j ACCEPT

# puppet clients listen on this port from the puppet master server
$IPTABLES -A OUTPUT -p tcp -d $NET_INT -m tcp --dport 8139 -m state --state NEW -j ACCEPT

# allow only 'echo-request' ping initiated from this host to internal net
$IPTABLES -A OUTPUT -p icmp --icmp-type echo-request -d $NET_INT -j ACCEPT

# allow cups network printing
$IPTABLES -A OUTPUT -p tcp -d $NET_INT -m tcp --dport 631 -m state --state NEW -j ACCEPT

# multicast mDNS implementation by Avahi to detect network device e.g. printers 
$IPTABLES -A OUTPUT -p udp -d $MDNSMULTICASTADDR -m udp --dport 5353 -m state --state NEW -j ACCEPT

# anything for the printer from this host
$IPTABLES -A OUTPUT -p tcp -d $NETPRN_HP3015_ADDR -j ACCEPT
$IPTABLES -A OUTPUT -p udp -d $NETPRN_HP3015_ADDR -j ACCEPT


#-------------------------------------
# Prevent invalid output packages out
#-------------------------------------
$IPTABLES -A OUTPUT -m state --state INVALID -j $LOGOPT $RLIMIT --log-prefix "DROP OUTPUT INVALID "
$IPTABLES -A OUTPUT -m state --state INVALID -j DROP


#---------------------------------------------------------------------
# CATCH ALL LOG-and-DROP RULES (you may be suprised what ends up here)
#---------------------------------------------------------------------

$IPTABLES -A OUTPUT ! -o lo -j $LOGOPT $RLIMIT --log-prefix "DROP OUTPUT DEFAULT "
$IPTABLES -A OUTPUT ! -o lo -j DROP


#############################
## SAVE THE FILE
#############################

$IPTSAVE > $IPTSAVEFILE
chmod 700 $IPTSAVEFILE

#############################
## LIST LOADED IPTABLES RULES
#############################

$IPTABLES -L -v --line-numbers

exit 0

