##
## Manage software raid
##
class puppet_raid::config {

    file { '/etc/mdadm/mdadm.conf':
        source => "puppet:///modules/puppet_raid/mdadm.conf",    
         owner => 'root',
         group => 'root',
       require => Class["puppet_raid::install"],
    }    
    
    # mount point for the data directory (raid 1)
    
	file { "/mnt/shireraid":
		ensure => "directory",
		 owner => 'root',
		 group => 'root',
	}

}