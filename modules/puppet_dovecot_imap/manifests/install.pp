##
## Install the dovecot package 
##
class puppet_dovecot_imap::install {

    $dovecotlist = [ "dovecot-core", "dovecot_imapd" ]
    
    package { [ "$dovecotlist" : ensure => present }
    
}