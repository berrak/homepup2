##
## This class manage the system 'fstab' file. Place a host specific file
## in the source directory prefixed with output of 'blkid'.+ hostname'+"."+"fstab"
## like so:
##      '064b4f90-9c73-49ea-8734-9b62bfd55471.carbon.fstab
## and a master CSV file ('fstab_sda1_uuid.csv') containing the sda1 disk 
## UUID like so: 'carbon,"064b4f90-9c73-49ea-8734-9b62bfd55471"' one row for
## each host name and UUID #.
##
## Sample use:
##    class { admin_fstab : fstabhost => 'carbon' }
##
class admin_fstab ( $fstabhost='', $source = 'UNSET' ) {
	
	
    # this is the original data file for each host 
    $real_source = $source ? {
        'UNSET' => "puppet:///modules/admin_fstab/fstab_sda1_uuid.csv",
        default => $source,
	}

    # this is the UUID data CSV for for host - this will stop P't
	# if file does not exist.
	file { "/etc/puppet/files/fstab_sda1_uuid.csv" : 
		 source => $real_source,
		  owner => 'root',
		  group => 'root',
	}
	
    $fstab_uuid_sda1 = extlookup( "$fstabhost", "FSTAB_UNCOPIED_TO_PUPPET_MASTER" )
	notify{"Disk, sda1-uuid for ($fstabhost) is ($fstab_uuid_sda1)" : }
	
	# This will ensure we use the correct disk data and not coorupt fstab
	if $fstab_uuid_sda1 != 'FSTAB_UNCOPIED_TO_PUPPET_MASTER'  {
		
		file { "/etc/fstab":
				source => "puppet:///modules/admin_fstab/064b4f90-9c73-49ea-8734-9b62bfd55471.${fstabhost}.fstab",
				owner => 'root',
				group => 'root',
				mode => '644',
		}
		
    }


}
