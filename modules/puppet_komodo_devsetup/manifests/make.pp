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
	
    $builddirectory = $::puppet_komodo_devsetup::params::builddirectory
	
	# Local source files are copied and installed on this remote host
    $remotefqdn = $::puppet_komodo_devsetup::params::remotefqdn
	
    # help file for remote developers (runs make and make install)
	$remote_install_scriptname = $::puppet_komodo_devsetup::params::remote_install_scriptname		
	
	
	## install makefile and copybook file in right place
	
	if $name == $sourcename {
	
		
		file { "/home/${username}/${projectname}/${sourcename}/makefile":
			content =>  template("puppet_komodo_devsetup/makefile.${name}.erb"),  
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}"], Class["puppet_komodo_devsetup::project"]],
		}
		
		
		# Files in copybook sub directory
		
		file { "/home/${username}/${projectname}/${sourcename}/${copybookname}/sqlca.cpy":
		     source => "puppet:///modules/puppet_komodo_devsetup/sqlca.cpy",
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}/${sourcename}/${copybookname}"], Class["puppet_komodo_devsetup::project"]],
		}		
		
		# symlink sqlca.cbl --> sqlca.cpy (library OCESQL requires the extension 'cbl')
		
		file { "/home/${username}/${projectname}/${sourcename}/${copybookname}/sqlca.cbl":
		  ensure => link,
		   owner => $username,
		   group => $groupname,
		  target => "/home/${username}/${projectname}/${sourcename}/${copybookname}/sqlca.cpy",
		  require => File["/home/${username}/${projectname}/${sourcename}/${copybookname}/sqlca.cpy"],
		}
		
		file { "/home/${username}/${projectname}/${sourcename}/${copybookname}/${sourcename}_setupenv_${projectname}.cpy":
		     source => "puppet:///modules/puppet_komodo_devsetup/${sourcename}_setupenv_${projectname}.cpy",
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}/${sourcename}/${copybookname}"], Class["puppet_komodo_devsetup::project"]],
		}			
		
		
	}
		
	if $name == $libraryname {
		
		file { "/home/${username}/${projectname}/${libraryname}/makefile":
			content =>  template("puppet_komodo_devsetup/makefile.${name}.erb"),  
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}"], Class["puppet_komodo_devsetup::project"]],
		}
		
		
		# Files in copybook sub directory
		
		# rename 'cbl' copybook to standard 'cpy' extension (library OCESQL requires extension cbl though)
		
		file { "/home/${username}/${projectname}/${libraryname}/${copybookname}/sqlca.cpy":
		     source => "puppet:///modules/puppet_komodo_devsetup/sqlca.cpy",
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}/${libraryname}/${copybookname}"], Class["puppet_komodo_devsetup::project"]],
		}				
		
		# symlink sqlca.cbl --> sqlca.cpy (library OCESQL requires the extension 'cbl')
		
		file { "/home/${username}/${projectname}/${libraryname}/${copybookname}/sqlca.cbl":
		  ensure => link,
		   owner => $username,
		   group => $groupname,		  
		  target => "/home/${username}/${projectname}/${libraryname}/${copybookname}/sqlca.cpy",
		  require => File["/home/${username}/${projectname}/${libraryname}/${copybookname}/sqlca.cpy"],		  
		}
		
		file { "/home/${username}/${projectname}/${libraryname}/${copybookname}/${libraryname}_setupenv_${projectname}.cpy":
		     source => "puppet:///modules/puppet_komodo_devsetup/${libraryname}_setupenv_${projectname}.cpy",
			  owner => $username,
			  group => $groupname,
			require => [ File["/home/${username}/${projectname}/${libraryname}/${copybookname}"], Class["puppet_komodo_devsetup::project"]],
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