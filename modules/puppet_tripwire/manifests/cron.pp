##
## This class manage our cron job (tripwire)
##
class puppet_tripwire::cron {
	
#    file { "/etc/cron.daily/tripwire" :
#		source => "puppet:///puppet_tripwire/cron.tripwire",
#		 owner => 'root',
#		 group => 'root',
#		  mode => '0700',
#    }


    file { "/etc/cron.d/tripwire" :
		source => "puppet:///puppet_tripwire/cron.tripwire",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',
    }




}
