##
## Parameters for make configuration
##
class puppet_komodo_devsetup::params {

    # Basic directory structure for the COBOL project
    
    $libraryname = 'lib'
	$sourcename = 'src'
	$toolsname = 'tools'	
	$copybookname = 'copy'
    $htmlname = 'html'
	$phpname = 'php'
 
    # before creating 'tar' arhieve, 'make' copies all HTML and BINARY files to this location
    $builddirectory = 'build'
	$cblbinaryname = 'bin'
    
}