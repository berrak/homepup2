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
    
 

}