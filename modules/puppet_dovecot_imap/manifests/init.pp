##
## Class to manage imap server (dovecot)
##
class puppet_dovecot_imap {

    include puppet_dovecot_imap::install, puppet_dovecot_imap::service
    include puppet_dovecot_imap::config, puppet_dovecot_imap::params

}