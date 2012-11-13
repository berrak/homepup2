##
## Parameters used to set what version to pin
## a specific package.
##
class puppet_iptables::params {
    
    # default single interface data (e.g. for desktop host)
    #------------------------------------------------------
    
    $net_int = '192.168.0.0/24'
    $if_int = 'eth0'
    
    
    # time server
    #-------------  
    
    $ntphostaddr = '192.168.0.1'
    
    
    # net printers
    #-------------
    
    $netprn_hp3015_addr = '192.168.0.30'

    
    # puppet server
    #--------------
    
    $puppetserveraddr = '192.168.0.24'
    
    
    # mail/imap server
    #------------------
    
    $smtphostaddr = '192.168.0.11'
    
    
    # file server (incl log host)
    #------------------------------
    $fileserveraddr = '192.168.0.83'
    

}