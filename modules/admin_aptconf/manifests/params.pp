##
## Parameters for apt
##
class admin_aptconf::params {

    # required for firmware to realtek nic drivers

    $mynonfreehost = 'asgard'
    
    
    # hosts that have /tmp on separate partition and mounted 'noexec'
    
    $hosttmpremountexeclist = [ 'asgard', 'gondor' ]

}