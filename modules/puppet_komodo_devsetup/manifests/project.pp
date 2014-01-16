##
## Manage source build (with make)
##
##  This creates the project structure and copies the makefiles
##
##
##  class { puppet_komodo_devsetup::project :
##     projectname => 'openjensen',
##		  username => 'bekr',
##       groupname => 'bekr',
##
## } 
##
class puppet_komodo_devsetup::project ( $projectname='', $username='', $groupname='' ) {

    include puppet_komodo_devsetup::params
	
    $sourcename = $::puppet_komodo_devsetup::params::sourcename	
    $libraryname = $::puppet_komodo_devsetup::params::libraryname
    $copybookname = $::puppet_komodo_devsetup::params::copybookname
    $htmlname = $::puppet_komodo_devsetup::params::htmlname	

    $builddirectory = $::puppet_komodo_devsetup::params::builddirectory	
	
	if $projectname =='' {
		fail("FAIL: Missing required project name!")
	}
	
	if $username =='' {
		fail("FAIL: Missing required user name!")
	}
	
	if $groupname =='' {
		fail("FAIL: Missing required group name!")
	}	

    
	## Create the project directory structure
	
	file { "/home/${username}/${projectname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,      
	}
	
	
	## Build output directories for the final build (only binaries)
	
	
	file { "/home/${username}/${projectname}/${builddirectory}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}
	
	file { "/home/${username}/${projectname}/${builddirectory}/${sourcename}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File[ "/home/${username}/${projectname}/${builddirectory}"],
	}
	
	file { "/home/${username}/${projectname}/${builddirectory}/${libraryname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File[ "/home/${username}/${projectname}/${builddirectory}"],
	}
	
	
	
	## create the individual sub directories for Cobol source and Cobol library source	
			
	# Cobol source files
	
	file { "/home/${username}/${projectname}/${sourcename}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}			
						
	# Cobol dynamic library source files		
	
	file { "/home/${username}/${projectname}/${libraryname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}				
	
	# Copybook directory (common use for src and lib)
	
	file { "/home/${username}/${projectname}/${copybookname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}
	
	# Files in copybook sub directory
	
	# rename 'cbl' copybook to standard 'cpy' extension (library OCESQL requires extension cbl though)
	
	file { "/home/${username}/${projectname}/${copybookname}/sqlca.cpy":
		 source => "puppet:///modules/puppet_komodo_devsetup/sqlca.cpy",
		  owner => $username,
		  group => $groupname,
		require => File["/home/${username}/${projectname}/${copybookname}"],
	}				
	
	# symlink sqlca.cbl --> sqlca.cpy (library OCESQL requires the extension 'cbl')
	
	file { "/home/${username}/${projectname}/${copybookname}/sqlca.cbl":
	  ensure => link,
	   owner => $username,
	   group => $groupname,		  
	  target => "/home/${username}/${projectname}/${copybookname}/sqlca.cpy",
		require => File["/home/${username}/${projectname}/${copybookname}/sqlca.cpy"],	  
	}
	
	file { "/home/${username}/${projectname}/${copybookname}/setupenv_${projectname}.cpy":
		 source => "puppet:///modules/puppet_komodo_devsetup/setupenv_${projectname}.cpy",
		  owner => $username,
		  group => $groupname,
		require => File["/home/${username}/${projectname}/${copybookname}"],
	}			
	
	
	
	# html directory
	
	file { "/home/${username}/${projectname}/${htmlname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}
	
	
	## install the top makefile's for the project
	
	file { "/home/${username}/${projectname}/makefile":
	    content =>  template('puppet_komodo_devsetup/makefile.root.erb'),  
		  owner => $username,
		  group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}
	
	## Install a README
	
	file { "/home/${username}/${projectname}/README.komodo":
		     source => "puppet:///modules/puppet_komodo_devsetup/README.komodo",
		  owner => $username,
		  group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}	
	
	
	
}