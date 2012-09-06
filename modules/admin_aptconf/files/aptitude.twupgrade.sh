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
if [ $1 = "-y" ] ; then
    assume-yes = $1
els
    assume-yes = ""
fi

OPT="--prompt --show-versions --verbose --without-recommends $assume-yes"

/usr/bin/aptitude update

if [ $? -eq 0 ] ; then
    /usr/bin/aptitude $OPT safe-upgrade
fi

if [ -d "/etc/tripwire" ] ; then 
    /root/bin/tripwire.check
else
    echo "Tripwire is not installed - skipping integrity database update."
fi

exit 0
