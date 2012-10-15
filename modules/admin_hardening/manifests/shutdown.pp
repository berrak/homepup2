##
## Hardening a host. Tiger explanation reference in [..]
##
class admin_hardening::system {

    # only allow root to use Ctrl-Alt-Del to reboot [lin007w]
    
    include puppet_utils
    
    puppet_utils::append_if_no_such_line { "ctrlaltdel_allow" :
            
        file => "/etc/shutdown.allow",
        line => "# This line prevents false positives from tiger." 
    
    }
    
}