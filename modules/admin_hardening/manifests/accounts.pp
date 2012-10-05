##
## Hardening a host. Tiger explanation reference in [..]
##
class admin_hardening::accounts {

    include accounts::virtual
    
    # tiger [acc022w] - no accesible home directory
    
    realize(User["nobody"])
    
}