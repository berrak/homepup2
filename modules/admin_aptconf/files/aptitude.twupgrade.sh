#!/bin/bash
#
# /root/bin/upgrade
#
###############################################################
# MANAGED BY PUPPET. DO NOT EDIT. CHANGES WILL BE WIPED OUT.  #
###############################################################
# Console usage: upgrade [option]
# aptitude safe-upgrade with (possible) tripwire run

# $1 can hold any additional options, but here we receive '-y'

if [ -z $1 ] ; then
    OPT="--prompt --show-versions --verbose --without-recommends"
else
    OPT="--prompt --show-versions --verbose --without-recommends $1"
fi

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
