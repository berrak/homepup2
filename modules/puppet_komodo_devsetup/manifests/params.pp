##
## Parameters for make configuration
##
class puppet_komodo_devsetup::params {

    # Basic directory structure for the COBOL project
    
    $libraryname = 'lib'
	$sourcename = 'src'
	$copybookname = 'copy'
    $htmlname = 'html'	
 
    # before creating 'tar' arhieve, 'make' copies all files to this location
    $builddirectory = 'build'
    
	# Remote host to scp local source files and then install to public directory
    $remotefqdn = 'mc-butter.se'
	$remoteusername = 'jensen'
	
	
	# help script to allow remote developers make and make install on server
    $remote_install_scriptname = 'remote_make_makeinstall'
	


}