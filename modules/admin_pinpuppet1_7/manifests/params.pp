##
## Parameters used to set what version to pin
## a specific package.
##
class admin_pinpuppet1_7::params {

    $mypuppetserver_hostname = 'carbon'

    $pin_priority = '1001'

    # pin puppet version to 1.7-branch

    $puppetmaster_version = '1.7'
    $puppetmaster_common_version = '1.7'
    
    $puppet_version = '1.7'
    $puppet_common_version = '1.7'
    
    # pin facter and rubyllib version to 1.6-branch and to 1.9-branch respectively
    
    $facter_version = '1.6'
    $rubylib_version = '1.9.1'
    

}