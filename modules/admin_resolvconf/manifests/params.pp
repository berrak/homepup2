##
## parameters for 'resolv.conf'
##
class admin_resolvconf::params {

    # my isp dns domains servers
    
    $ispdns_ip_1st = '195.67.199.18'
    $ispdns_ip_2nd = '195.67.199.19'
    
    # alternative open dns domain servers
    
    $opendns_ip_1st = '208.67.222.222'
    $opendns_ip_2nd = '208.67.220.220'
    
    # To have postfix deliver mails from subdomains.
    # Any sub domain must end with 'home.tld'
    
    $mysubdomain_1 = 'sec.home.tld'
    

}