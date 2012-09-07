##
## This class manage our cron job (tripwire)
##
class puppet_tripwire::cron {
	
		
    include puppet_utils

    puppet_utils::append_if_no_such_line { "Add_tripwire_placeholder" :
		
	    file => "/etc/cron.daily/tripwire",
	    line => "PUPPET: Do not remove. Prevents TW maintainer putting tripwire job here." 
    }
	

    # Set up the cron job for 
	
	cron { tripwire-test :
				command => '/root/bin/tripwire.check',
			environment => 'PATH=/root/bin:$PATH',
				   user => 'root',
				   hour => [ 7, 13, 21 ],
				 minute => '19 ',
	}

}
