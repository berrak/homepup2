##
## This class manage our cron job (tripwire)
##
class puppet_tripwire::cron {
	
    file { "/etc/cron.daily/tripwire" :
		source => "puppet:///puppet_tripwire/cron.tripwire",
		 owner => 'root',
		 group => 'root',
    }


}
