#
# Configure rsyslog. 
#
class admin_rsyslog::config {

    include admin_rsyslog::params
    
    if $::hostname == $::admin_rsyslog::params::myloghost {
     
        include admin_rsyslog::params
     
        $srvremotepath = $::admin_rsyslog::params::logsrvremotepath
        
        file { '/etc/rsyslog.conf':
             source => "puppet:///modules/admin_rsyslog/rsyslog.loghost.conf",
              owner => 'root',
              group => 'root',
            require => Class["admin_rsyslog::install"],
             notify => Class["admin_rsyslog::service"],
        }        
        
        # create a directory for all remote logs
        
        file { '/var/log/remotelogs' :
            ensure => directory,
        	 owner => 'root',
	 	     group => 'adm',
		      mode => '0755',
        }
        
    
    } else {
    
        file { '/etc/rsyslog.conf':
             source => "puppet:///modules/admin_rsyslog/rsyslog.conf",
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