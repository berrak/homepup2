##
## Define to copy fstab to host
##
## Sample use:
##    class { admin_fstab::config : fstabhost => 'carbon' }
##
class admin_fstab::config ( $fstabhost='', $source = 'UNSET' ) {

    include admin_fstab
    
	$server_source = $source ? {
		'UNSET' => "puppet:///modules/admin_fstab/fstab_sda1_uuid.csv",
		default => $source,
	}
	
	$serverpath = "/etc/puppet/files/fstab_sda1_uuid.csv"

	file { "$serverpath" : 
		 source => $server_source,
		  owner => 'root',
		  group => 'root',
	}
	
    # Look up the UUID for this hosts sda1 partition (to be sure not doing any bad)

    $fstab_uuid_sda1 = extlookup( "$fstabhost", "FSTAB_UNCOPIED_TO_PUPPET_MASTER" )
    
    if $fstab_uuid_sda1 == 'FSTAB_UNCOPIED_TO_PUPPET_MASTER' {
        notify{"Disk, the lowest partition in this host fstab file, normally sda1, uuid for ($fstabhost) is ($fstab_uuid_sda1)" : }
    }
    
	# This will ensure we use the correct disk data and not corrupt fstab
	
	if $fstab_uuid_sda1 != 'FSTAB_UNCOPIED_TO_PUPPET_MASTER'  {
		
        # If UUID from grep does not match on target host, Puppet will not touch existing fstab.
		# We always use sda1 unless its occupied by some other operating system (e.g. win32).
		# If so, use the lowest partition available, e.g. sda5 as identification for fstab file.
        
        exec { "Verifying_disk_UUID_match_fstab_data" :
                command => "/bin/grep -w '$fstab_uuid_sda1' '/etc/fstab'",
        }
        
		file { "/etc/fstab":
			 source => "puppet:///modules/admin_fstab/${fstab_uuid_sda1}.${fstabhost}.fstab",
			  owner => 'root',
			  group => 'root',
			   mode => '644',
            require => Exec["Verifying_disk_UUID_match_fstab_data"],
		}
		
    }

}