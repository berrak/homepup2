##
## This class manage the system 'fstab' file. Place a host specific file
## in the source directory prefixed with output of 'blkid'.+ hostname'+"."+"fstab"
## like so:
##      '064b4f90-9c73-49ea-8734-9b62bfd55471.carbon.fstab
## and a master CSV file ('fstab_sda1_uuid.csv') containing the sda1 disk 
## UUID like so: 'carbon,"064b4f90-9c73-49ea-8734-9b62bfd55471"' one row for
## each host name and UUID #.
##
##
class admin_fstab {

    # this is the UUID data CSV for for all hosts - this will 
	# stop P't at this host if this file does not exist.
	
	file { "/etc/puppet/files/fstab_sda1_uuid.csv" : 
		  source => "puppet:///modules/admin_fstab/fstab_sda1_uuid.csv",
		   owner => 'root',
		   group => 'root',
	}
	
}
