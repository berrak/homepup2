##
## Backup user data with rsnapshot
##
## Usage:
##        puppet_rsnapshot::desktop_user { 'bekr' : }
##
define puppet_rsnapshot::desktop_user {

	include puppet_rsnapshot
	
    ## Create per user defined configuration
    
	file { "/home/${name}/.rsnapshot":
		ensure => "directory",
		owner => "${name}",
		group => "${name}",
		mode => '0750',
	}    
    
    $nfs_backup_directory = 'backup'
    $myhostname = $::hostname
	
    file { "/home/${name}/.rsnapshot/rsnapshot.conf":
        content =>  template("puppet_rsnapshot/${name}.rsnapshot.conf.erb"),
          owner => "${name}",
          group => "${name}",
           mode => '0600',
        require => File["/home/${name}/.rsnapshot"],
    }
    
    ## Add indidual user cron jobs
    
    file { "/etc/cron.d/rsnapshot-${name}":
        content =>  template("puppet_rsnapshot/rsnapshot.erb"),
        require => Package["rsnapshot"], 
    }

}
