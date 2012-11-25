##
## Parameters to erb template
##
class puppet_logwatch::params {

    # who should receive email reports from logwatch runs
    # this is relayed to central mail server were it is
    # aliased from root to a normal user account.
    
    # Note use an absolute domain in case this host is
    # in a diffrent (sub)domain that the mail server.
    
    $myrcpt = 'root@home.tld'

}