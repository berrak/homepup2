##
## This class manage the system 'fstab' file. Place a host specific file
## in the source directory prefixed with output of 'blkid'.+ hostname'+"."+"fstab"
## like so:
##      '064b4f90-9c73-49ea-8734-9b62bfd55471.carbon.fstab
## and a CSV file (e.g. 'carbon.csv') containing the sda1 disk UUID like so:
##		'carbon, 064b4f90-9c73-49ea-8734-9b62bfd55471'
##
## Sample use:
##    class { admin_fstab : fstabhost => 'carbon' }
##
class admin_fstab ( $fstabhost='', $source = 'UNSET' ) {
	
	$extlookup_datadir = "/etc/puppet/files"
	
    # this is the original data file for each host 
    $real_source = $source ? {
        'UNSET' => "puppet:///modules/admin_fstab/${fstabhost}.csv",
        default => $source,
	}
	
    $fstab_uuid_sda1 = extlookup( $fstabhost, "FSTAB_UNCOPIED_TO_PUPPET_MASTER" )
	notify{"Disk, sda1-uuid for ($fstabhost) is ($fstab_uuid_sda1)" : }
	
	
	if $fstab_uuid_sda1 != 'FSTAB_UNCOPIED_TO_PUPPET_MASTER'  {
	
		# this is the UUID data CSV for for host 
		file { "/etc/puppet/files/${fstabhost}.csv" : 
			 source => $real_source,
			  owner => 'root',
			  group => 'root',
		}
		
		file { "/etc/fstab":
				source => "puppet:///modules/admin_fstab/064b4f90-9c73-49ea-8734-9b62bfd55471.${fstabhost}.fstab",
				owner => 'root',
				group => 'root',
				mode => '644',
		}
		
    }


}
