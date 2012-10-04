##
## Hardening a host. Tiger explanation reference in [..]
##
class admin_hardening::system {

    # only allow root to use Ctrl-Alt-Del to reboot [lin007w]
    
    file { "/etc/shutdown.allow":
        enure => present,
        owner => 'root',
        group => 'root',
    }
    

}