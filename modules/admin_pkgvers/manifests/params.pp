##
## Parameters used to set what version to pin
## a specific package.
##
class admin_pkgvers::params {

    $mypuppetserver_hostname = 'carbon'

    $pin_priority = '1001'

    $puppetmaster_version = '1.7'
    $puppetmaster_common_version = '1.7'
    
    $puppet_version = '1.7'
    $puppet_common_version = '1.7'
    
    $facter_version = '1.6'
    $rubylib_version = '1.8'
    

}