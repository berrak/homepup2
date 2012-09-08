#
# Define (install) a root cron job
#
define admin_cron::install (
		$ensure=present,
		$command='',
		$user='root,
		$hour=undef,
		$minute=undef,
		$month=undef,
		$monthday=undef,
		$weekday=endef,
		$environment='PATH=/root/bin:/sbin:/bin'
		$special=undef,
) {

    if $command == '' {
		fail("FAIL: $name is missing the command parameter ($command).")
	}

	cron { "$name":
		ensure		=> $ensure,
		command 	=> "$command",
  		user 		=> $user,
  		minute 		=> $minute,
		hour		=> $hour,
		month		=> $month,
		monthday	=> $monthday,
		weekday		=> $weekday,
		environment => $environment,
		special		=> $special,
	}
}
