##
## Hardening a host. Tiger explanation reference in [..]
##
class admin_hardening::accounts {

    # tiger [acc022w] - not a accesible home directory (was /nonexistent)
    
    realize(User["nobody"])
    
}