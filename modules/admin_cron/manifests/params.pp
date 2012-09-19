##
## Parameters for 'master' crontab template 
##
class admin_cron::params {

    # facter

    $mydomain = $::domain

    # All cron jobs in /etc/cron.* will be sent to this
    # recipient. (We will change this later since lots of mails).
    
    # Must use fqdn, otherwise mails will only go to postfix
    # local transport i.e. root on that host and not relayed to
    # our central lan postfix mail server.

    $myrecipient = "root@${mydomain}"


}