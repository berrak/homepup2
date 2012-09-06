#!/bin/sh -e
#
# /root/bin/aptitude.unattended_upgrade.sh
#
###############################################################
# MANAGED BY PUPPET. DO NOT EDIT. CHANGES WILL BE WIPED OUT.  #
###############################################################
#
# Runs an aptitude unattended (cron) script for security updates.
#
# Requires script 'upgrade' (which runs tripwire if available)
#
# Initial version without any error checks - todo.

UPGRADE="/root/bin/upgrade"
MV="/bin/mv"

ORIGINALSOURCEDIR="/etc/apt/sources.list.d"
SHADOWSOURCEDIR="/etc/apt/.sources.list.d"

# move the source snippets to our shadow directory

$MV $ORIGINALSOURCEDIR/* $SHADOWSOURCEDIR

# runs the upgrade with repos that only is in 'source.list'

$UPGRADE -y

# now move source snippets back to its original place

$MV $SHADOWSOURCEDIR/* $ORIGINALSOURCEDIR

exit 0

