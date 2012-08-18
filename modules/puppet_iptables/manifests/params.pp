##
## Parameters used to set what version to pin
## a specific package.
##
class puppet_iptables::params {

    $mygateway_hostname = 'gondor'
    $mypuppetmaster_hostname = 'carbon'
    
    # desktops
    
    $net_int = '192.168.0.0/24'
    $if_int = 'eth0'
    
    $ntphostaddr = '192.168.0.1'
    
    # net printers
    $netprn_hp3015_addr = '192.168.0.30'
    
    # special addresses
    $mdnsmulticastaddr = '224.0.0.251'
    $puppetmasterhostaddr = '192.168.0.24'


    # gateway gondor (use also desktop variables '$net_int' and '$if_int' and printers ip)
    $gwhostaddr = '192.168.0.1'
    
    $net_ext = '192.168.1.0/24'
    $gwhostextaddr = '192.168.1.254'
    $if_ext = 'eth1'

}