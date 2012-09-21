##
## Parameters for dovecot configuration
##
class puppet_dovecot_imap::params {

    # these users must have a system account on the lan mail server
    
    $myuser1 = 'bekr'
    $myuser2 = 'dakr'
    
    ##########################################################################
    #
    # Note: only for initial tests of the internal mail system and before we
    # enable authentiaction and encryption to hide clear text pwds on the wire
    #
    ##########################################################################
    
    # these are the exact line used in the file '/etc/dovecot/imap.passwd'
    
    $myuser1pwd = 'bekr:{PLAIN}pass'
    $myuser2pwd = 'dakr:{PLAIN}pass'    


}