#!/bin/bash
#
# /user/local/bin/backup_to_user_nfs.sh
#
###############################################################
# MANAGED BY PUPPET. DO NOT EDIT. CHANGES WILL BE WIPED OUT.  #
###############################################################

LOGGER=/usr/bin/logger
RSNAPSHOT=/usr/bin/rsnapshot

###############################
# MAIN PROGRAM
###############################

# This scripts is run at lightdm session start (i.e user
# login). User environment is set like $HOME and $USER.

# Don't run this for 'root' (single '=' works for dash also)

if [ "$USER" = "root" ]; then
    $LOGGER -p local0.debug "$0: Error! Root is not allowed in backup script! User ($USER) in ($HOME)."
    exit
fi

# Ensure we have network connection to backup to NFS

if test -d /"$HOME"/nfs/backup ; then

    $LOGGER -p local0.debug "$0: Backup with rsnapshot ($HOME) to ($USER)-NFS."
    $RSNAPSHOT -c /"$HOME"/.rsnapshot/rsnapshot.conf sync
    $RSNAPSHOT -c /"$HOME"/.rsnapshot/rsnapshot.conf hourly

fi

exit
