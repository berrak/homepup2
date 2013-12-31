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
	
	
	## Build output directories for the final build target
	
	
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
	
	file { "/home/${username}/${projectname}/${builddirectory}/${sourcename}/${copybookname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File[ "/home/${username}/${projectname}/${builddirectory}/${sourcename}"],
	}	
	
	file { "/home/${username}/${projectname}/${builddirectory}/${libraryname}/${copybookname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File[ "/home/${username}/${projectname}/${builddirectory}/${libraryname}"],
	}
	
	
	
	
	## create the individual sub directories for Cobol source and Cobol library source	
			
	# Cobol source files
	
	file { "/home/${username}/${projectname}/${sourcename}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}			
			
	file { "/home/${username}/${projectname}/${sourcename}/${copybookname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}/${sourcename}"],
	}				
			
			
	# Cobol dynamic library source files		
	
	file { "/home/${username}/${projectname}/${libraryname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}			
	
	file { "/home/${username}/${projectname}/${libraryname}/${copybookname}":
		ensure => "directory",
		owner => $username,
		group => $groupname,
		require => File["/home/${username}/${projectname}/${libraryname}"],
	}		
	

	
	
	## install the top makefile's for the project
	
	file { "/home/${username}/${projectname}/makefile":
	    content =>  template('puppet_komodo_devsetup/makefile.root.erb'),  
		  owner => $username,
		  group => $groupname,
		require => File["/home/${username}/${projectname}"],
	}
	
}