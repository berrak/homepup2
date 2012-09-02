##
## This class manage the system 'fstab' file. Place a host specific file
## in the source directory prefixed with output of 'hostname'+"."+"fstab"
## and a CSV file (e.g. 'carbon.csv') containing the sda1 disk UUID like so:
##		'uuid, 064b4f90-9c73-49ea-8734-9b62bfd55471'
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
	
	# this is the UUID data CSV for for host 
    file { "/etc/puppet/files/${fstabhost}.csv" : 
         source => $real_source,
          owner => 'root',
          group => 'root',
    }
	
	$fstab_uuid_sda1 = extlookup( $fstabhost, "FSTAB_UNCOPIED_TO_PUPPET_MASTER" )
	
	notify{"external uuid lookup returns ($fstab_uuid_sda1) for ($fstabhost)" : }
	
    # TODO
	# 1. use $fstabhost to read in host and disk uuid (rrot) from external cv-file.
	
	# 2. if host is not found, skip the fstab sourcing below
	
	# 3. do not fail but print notify about missing fstab
	
	# 4. if host match then compare the host uuid with the named hostuuid fstab:
	# '064b4f90-9c73-49ea-8734-9b62bfd55471.fstab_uuid_sda1_carbon'
	
	
	
	#if ! ( $fstabhost in [ "carbon", "gondor", "rohan", "mordor" ] ) {
	#
	#	fail("FAIL: Could not find ($fstabhost) fstab file on puppetmaster! Please copy it over.")
	#
	#}

    

	file { "/etc/fstab":
		source => "puppet:///modules/admin_fstab/${fstabhost}.fstab",
		owner => 'root',
		group => 'root',
		mode => '644',
	}


}
