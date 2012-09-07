#!/bin/sh
#
# /root/bin/upgrade.security
#
###############################################################
# MANAGED BY PUPPET. DO NOT EDIT. CHANGES WILL BE WIPED OUT.  #
###############################################################
#
# Runs script for security updates (unattended).
#
# Requires script 'upgrade' (which runs tripwire if available)
# and use aptitude, but in principle could be apt-get as well.
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

UPGRADE="/root/bin/upgrade"
MV="/bin/mv"
MKDIR="/bin/mkdir"

ORIGINALSOURCEDIR="/etc/apt/sources.list.d"
SHADOWSOURCEDIR="/etc/apt/.sources.list.d"

# test if both directories exists, create them if not.

if [ ! -d $ORIGINALSOURCEDIR ] ; then
    $MKDIR $ORIGINALSOURCEDIR
fi

if [ ! -d $SHADOWSOURCEDIR ] ; then
    $MKDIR $SHADOWSOURCEDIR
fi

# move the source snippets to our shadow directory
# redirect stderr to /dev/null in case no files found

$MV $ORIGINALSOURCEDIR/* $SHADOWSOURCEDIR 2> /dev/null
movedfiles=$?

# runs the upgrade with repos that only is in 'sources.list'
# which is security important and 'safe' to run unattended.

$UPGRADE -y

# move possible source snippets back to its original place

if [ $movedfiles -eq 0 ] ; then
    $MV $SHADOWSOURCEDIR/* $ORIGINALSOURCEDIR
fi

exit 0

