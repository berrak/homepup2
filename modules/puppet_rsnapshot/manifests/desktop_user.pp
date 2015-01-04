##
## Backup user data with rsnapshot
##
## Usage:
##        puppet_rsnapshot::desktop_user { 'bekr' : }
##
define puppet_rsnapshot::desktop_user {

    include puppet_utils

    ## Create per user defined configuration
    
	file { "/home/${name}/.rsnapshot":
		ensure => "directory",
		owner => "${name}",
		group => "${name}",
		mode => '0750',
	}    
    
    file { "/home/${name}/.rsnapshot/rsnapshot.conf":
        content =>  template('puppet_rsnapshot/${name}.rsnapshot.conf.erb'),
          owner => "${name}",
          group => "${name}",
           mode => '0700',
        require => File["/home/${name}/.rsnapshot"],
    }
    
    ## Ensure the backup-directory for rsnapshot exists
    
    $nfs_backup_directory = 'backup'
    
	file { "/home/${name}/nfs/${nfs_backup_directory}":
		ensure => "directory",
		owner => "${name}",
		group => "${name}",
		mode => '0700',
	}    
    
    ## Add cron jobs
    
    # TODO





}
