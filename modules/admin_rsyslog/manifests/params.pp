##
## Manage rsyslog
##
class admin_rsyslog::params {


    ## log server (i.e. the receiving log host)
    
    $myloghost = 'warp'
    
    $logsrvloadtcp = '$ModLoad imtcp'
    $logsrvportinput = '$InputTCPServerRun 1958'
    
    $logsrvremotepath = '/var/log/remotelogs'
    
    
    
    
    ## client (i.e. sending all rsyslog messages on tcp port 1958)
    
    $sendtologhost = '*.*         @@192.168.0.83:1958'

}