##
## Install the dovecot package 
##
class puppet_dovecot_imap::install {

    package { "dovecot" : ensure => present }
    
}