#
# Configure rsyslog. 
#
class admin_rsyslog::config {


    
    if $::hostname == $::admin_rsyslog::params::myloghost {
     
        include admin_rsyslog::params
     
        $srvloadtcp = $::admin_rsyslog::params::logsrvloadtcp
        $srvport = $::admin_rsyslog::params::logsrvportinput
        $srvremotepath = $::admin_rsyslog::params::logsrvremotepath
        
        file { '/etc/rsyslog.conf':
            content => template('/admin_rsyslog/rsyslog.conf.loghost.erb'),
              owner => 'root',
              group => 'root',
            require => Class["admin_rsyslog::install"],
             notify => Class["admin_rsyslog::service"],
        }        
        
        # create a directory for all remote logs
        
        file { $srvremotepath :
            ensure => directory,
        	 owner => 'root',
	 	     group => 'adm',
		      mode => '0755',
        }
        
    
    } else {

        include admin_rsyslog::params
    
        # $sendtohost = $::admin_rsyslog::params::sendtologhost
        
        file { '/etc/rsyslog.conf':
            content => template('/admin_rsyslog/rsyslog.conf.erb'),
              owner => 'root',
              group => 'root',
            require => Class["admin_rsyslog::install"],
             notify => Class["admin_rsyslog::service"],
        }
    
    }
    
    # logger wrapper script to test facilities.priorities at command line 
    
    file { '/root/bin/rsyslog.test':
         source => "puppet:///modules/admin_rsyslog/rsyslog.test",
          owner => 'root',
          group => 'root',
           mode => '0700',
        require => Class["admin_rsyslog::install"],
    }  
    
}