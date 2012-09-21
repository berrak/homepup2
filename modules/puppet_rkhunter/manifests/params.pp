##
## Parameters to erb template
##
class puppet_rkhunter::params {

    # facter
    
    $mydomain = $::domain 

    # who should receive email reports when rkhunter finds anything.
    # Mails is sent to root on local host and relayed to central
    # mail server were it is aliased from root to a normal user account.
    
    $myrcptdomain = "root@${mydomain}"
    $mylocalroot = 'root'
    
    # rkhunter requires white space separated list (option) of recipients
    # just send to root (which by postfix conf is relayed to central server)
    
    $rcptlist = $mylocalroot

}