##
## Define to copy fstab to host
##
## Sample use:
##    class { admin_fstab::config : fstabhost => 'carbon' }
##
class admin_fstab::config ( $fstabhost='' ) {

    include admin_fstab
    
    # Look up the UUID for this hosts sda1 partition (to be sure not doing any bad)
    # Unfortunately have no control when this function will execute, and thus will
    # not return anything the first P't run. Re-run P't and it works second run.
    
    $fstab_uuid_sda1 = extlookup( "$fstabhost", "FSTAB_UNCOPIED_TO_PUPPET_MASTER" )
	notify{"Disk, sda1-uuid for ($fstabhost) is ($fstab_uuid_sda1)" : }
	
	# This will ensure we use the correct disk data and not corrupt fstab
	
	if $fstab_uuid_sda1 != 'FSTAB_UNCOPIED_TO_PUPPET_MASTER'  {
		
		file { "/etc/fstab":
				source => "puppet:///${fstab_uuid_sda1}.${fstabhost}.fstab",
				owner => 'root',
				group => 'root',
				mode => '644',
		}
		
    }

}