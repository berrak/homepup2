##
## Hardening a host. Tiger explanation reference in [..]
##
class admin_hardening::system {

    # only allow root to use Ctrl-Alt-Del to reboot [lin007w]
    
    include puppet_utils
    
    puppet_utils::append_if_no_such_line { "ctrlaltdel_allow" :
            
        file => "/etc/shutdown.allow",
        line => "# This is just a place holder to prevent false positives from tiger." 
    
    }
    
    # set grub password to allow only the defined
    # (grub)superuser to edit entries [boot06]
    
	file { "/etc/grub.d/40_custom" :
		 source => "puppet:///modules/admin_hardening/40_custom",
		  owner => 'root',
		  group => 'root',
		   mode => '0755',
	}
    
}