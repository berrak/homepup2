#!/bin/bash
#
# /root/bin/upgrade
#
###############################################################
# MANAGED BY PUPPET. DO NOT EDIT. CHANGES WILL BE WIPED OUT.  #
###############################################################
# Console usage: upgrade [option]
# aptitude safe-upgrade with (possible) tripwire run
#
if [ "$1" = "-y" ] ; then
    yestoprompts = $1
else
    yestoprompts = ""
fi

OPT="--prompt --show-versions --verbose --without-recommends"

/usr/bin/aptitude update

if [ $? -eq 0 ] ; then
    /usr/bin/aptitude $OPT $yestoprompts safe-upgrade
fi

if [ -d "/etc/tripwire" ] ; then 
    /root/bin/tripwire.check
else
    echo "Tripwire is not installed - skipping integrity database update."
fi

exit 0
