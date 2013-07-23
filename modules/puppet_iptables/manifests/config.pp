##
## This class manage iptables rules. If not '$hostnm' is given a generic set
## of iptables rules is used (i.e. role => 'default'. Internal net and interface
## parameters can be given to override defaults '192.168.0.0/24' and 'eth0'
## (defined in params.pp)
##
##
## If $hostnm is given, this overrides $role (but must be given), and a
## specific $hostnm rule are used instead.
##
## Sample usage:
##     class { puppet_iptables::config : role => 'default.desktop' }
##     class { puppet_iptables::config : role => 'default.server', inet => '192.168.2.0/24' }
##
##     class { puppet_iptables::config : role => 'mailserver', hostnm => 'rohan' }
##
class puppet_iptables::config ( $role,
                                $inet= '',
                                $iface= '',
                                $hostnm= '',
) {

    include puppet_iptables

    if ! ( $role in [ 'default.desktop', 'default.server', 'mailserver', 'gateway', 'puppetmaster', 'fileserver' ]) {
	
		fail("FAIL: Unknown role parameter ($role).")
	
	}

    ## Use default configuration parameters or use supplied overrides.
	
	if ( $role == 'default.desktop' ) or ( $role == 'default.server' ) {
	
        if $inet == '' {
            $net_int = $::puppet_iptables::params::net_int
        } else {
		    $net_int = $inet
        }
		
        if $iface == '' {
            $if_int = $::puppet_iptables::params::if_int
        } else {
		    $net_int = $iface
        }		
		
	}
	
    # Special addresses are always used in default rules
    
    $ntphostaddr = $::puppet_iptables::params::ntphostaddr
    $netprn_hp3015_addr = $::puppet_iptables::params::netprn_hp3015_addr
    $puppetserveraddr = $::puppet_iptables::params::puppetserveraddr
	$smtphostaddr = $::puppet_iptables::params::smtphostaddr
	$fileserveraddr = $::puppet_iptables::params::fileserveraddr


	## facter	
		
	$myhostname = $::hostname	
		
    ## Select iptables rule ('default' firewall if not 'hostnm' given)
	
	if ( $hostnm == '' ) {
	
		file { "/root/bin/fw.${role}":
		    content => template( "puppet_iptables/fw.${role}.erb" ),
		      owner => 'root',
		      group => 'root',
		       mode => '0700',
		    require => File["/root/bin"],
		     notify => Exec["/bin/sh /root/bin/fw.${role}"],
		}
		
		exec { "/bin/sh /root/bin/fw.${role}":
		    refreshonly => true,
	    }
		
     } elsif ( $hostnm == $myhostname ) {
	
		file { "/root/bin/fw.${myhostname}":
		     source => "puppet:///modules/puppet_iptables/fw.${role}.${myhostname}",
		      owner => 'root',
		      group => 'root',
		       mode => '0700',
		    require => File["/root/bin"],
		     notify => Exec["/bin/sh /root/bin/fw.${myhostname}"],
		}
		
		exec { "/bin/sh /root/bin/fw.${myhostname}":
		    refreshonly => true,
	    }


     } else {
	
		fail("FAIL: Unknown parameter hostnm ($hostnm) given.")

    }

}
