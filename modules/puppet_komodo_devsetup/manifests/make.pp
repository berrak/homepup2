#
# Define new programming project
#
# Sample usage:
#
#     puppet_komodo_devsetup::make { 'src' :
#     		projectname => 'openjensen',
#		  	   username => 'jensen',
#             groupname => 'jensen',
#     } 
#
define puppet_komodo_devsetup::make ( $projectname='', $username='', $groupname='') {

	if $projectname =='' {
		fail("FAIL: Missing required project name!")
	}
	
	if $username =='' {
		fail("FAIL: Missing required user name!")
	}
	
	if $groupname =='' {
		fail("FAIL: Missing required group name!")
	}
	

    include puppet_komodo_devsetup::params
	
	
	## project file structure

    $sourcename = $::puppet_komodo_devsetup::params::sourcename	
    $libraryname = $::puppet_komodo_devsetup::params::libraryname
    $copybookname = $::puppet_komodo_devsetup::params::copybookname
    $htmlname = $::puppet_komodo_devsetup::params::htmlname
    $phpname = $::puppet_komodo_devsetup::params::phpname	
	
    # finished cobol binaries is put below /build/$cblbinaryname
	$cblbinaryname = $::puppet_komodo_devsetup::params::cblbinaryname
	
    $builddirectory = $::puppet_komodo_devsetup::params::builddirectory	
	
	## install makefile and copybook file in right place
	
	if $name == $sourcename {
	
		file { "/home/${username}/${projectname}/${sourcename}/makefile":
			content =>  template("puppet_komodo_devsetup/makefile.${name}.erb"),  
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}"], Class["puppet_komodo_devsetup::project"]],
		}
	}
		
	if $name == $libraryname {
		
		file { "/home/${username}/${projectname}/${libraryname}/makefile":
			content =>  template("puppet_komodo_devsetup/makefile.${name}.erb"),  
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}"], Class["puppet_komodo_devsetup::project"]],
		}
	}
	
	
	if $name == $htmlname {
		
		file { "/home/${username}/${projectname}/${htmlname}/makefile":
			content =>  template("puppet_komodo_devsetup/makefile.${name}.erb"),  
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}"], Class["puppet_komodo_devsetup::project"]],
		}
		
	}
 
    
}