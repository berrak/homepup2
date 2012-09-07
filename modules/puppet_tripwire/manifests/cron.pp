##
## This class manage our cron job (tripwire)
##
class puppet_tripwire::cron {
	
		
    include puppet_utils

    puppet_utils::append_if_no_such_line { "Add_tripwire_placeholder" :
		
	    file => "/etc/cron.daily/tripwire",
	    line => "PUPPET: Do not remove. TW use cron.d. Prevents Apt putting tripwire job here." 
    }
	
    # this is the real cron tripwire job in /etc/cron.d

    file { "/etc/cron.d/tripwire" :
		source => "puppet:///puppet_tripwire/cron.tripwire",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',
    }


}
