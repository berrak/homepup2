##
## Parameters for apt
##
class admin_aptconf::params {

    # required for firmware to realtek nic drivers

    $mynonfreehost = 'asgard'
    
    
    # hosts that have /tmp on separate partition and mounted 'noexec'
    # Todo: better idea to test if this partition exist or not than
    # managimg this list...easy to forget.
    
    $hosttmpremountexeclist = [ 'asgard', 'gondor', 'shire' ]

}