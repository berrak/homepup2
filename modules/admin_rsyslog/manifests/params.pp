##
## Manage rsyslog
##
class admin_rsyslog::params {


    ## log server (i.e. the receiving log host)

    $myloghost = 'warp'
    
    # all logfiles that rsyslog writes (local or remote) here will be checked
    
    $logcheckfilespath = '/var/log/logcheck'
    
}