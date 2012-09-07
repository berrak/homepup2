#!/bin/bash
#
# /root/bin/upgrade
#
###############################################################
# MANAGED BY PUPPET. DO NOT EDIT. CHANGES WILL BE WIPED OUT.  #
###############################################################
# Console usage: upgrade [option]
# runs in sequence: aptitude update, aptitude safe-upgrade
#                   and tripwire --check (if installed)
#
# Additional options can be e.g. '-y'| '--assumes-yes'
# Default options in $OPT (see below)
#   --prompt --show-versions --verbose --without-recommends
#
# Copyright (C) (2012) K-B.Kronlund <bkronmailbox-copyright@yahoo.se>
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

if [ -z $1 ] ; then
    OPT="--prompt --show-versions --verbose --without-recommends"
else
    OPT="--prompt --show-versions --verbose --without-recommends $1"
fi

/usr/bin/aptitude update

if [ $? -eq 0 ] ; then
    /usr/bin/aptitude $OPT safe-upgrade
fi


# tripwire.check is tripwire --check from a safe binary
if [ -d "/etc/tripwire" ] ; then 
    /root/bin/tripwire.check
else
    echo "Tripwire is not installed - skipping integrity database update."
fi

exit 0
