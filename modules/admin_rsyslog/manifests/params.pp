##
## Manage rsyslog
##
class admin_rsyslog::params {


    ## log server (i.e. the receiving log host)
    ############################################
    $myloghost = 'warp'
    
    $logsrvloadtcp = '$ModLoad imtcp'
    $logsrvportinput = '$InputTCPServerRun 1958'
    
    $logsrvremotepath = '/var/log/remotelogs'
    
    
    
    
    ## client config (i.e. sending almost all rsyslog messages to loghost)
    ######################################################################
    $sendtologhost = '*.*;auth,authpriv.none;kern.!emerg   @@192.168.0.83:1958'

}