#
# Define (install) a root cron job
#
define admin_cron::install (
		$command='',
		$hour=undef,
		$minute=undef,
		$month=undef,
		$monthday=undef,
		$weekday=undef,
		$special=undef,
) {

		$myensure = 'present'
		$mycommand = $command
		$myuser = 'root'
		$mypath = 'PATH=/root/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'

    if $command == '' {
		fail("FAIL: $name is missing the command parameter ($command).")
	}

	cron { "$name":
		ensure		=> $myensure,
		command 	=> $mycommand,
		environment => $mypath,
  		user 		=> $myuser,
  		minute 		=> $minute,
		hour		=> $hour,
		month		=> $month,
		monthday	=> $monthday,
		weekday		=> $weekday,
		special		=> $special,
	}
}
