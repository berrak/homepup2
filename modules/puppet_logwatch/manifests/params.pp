##
## Parameters to erb template
##
class puppet_logwatch::params {

    # facter
    
    $mydomain = $::domain 

    # who should receive email reports from logwatch runs
    # this is relayed to central mail server were it is
    # aliased from root to a normal user account.
    
    $myrcpt = "root@${mydomain}"

}