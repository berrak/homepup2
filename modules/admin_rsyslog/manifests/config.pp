#
# Configure rsyslog. 
#
class admin_rsyslog::config {

    include admin_rsyslog::params
    
    if $::hostname == admin_rsyslog::params::myloghost {
     
        $sendtohost = '#'
        $srvloadtcp = $::admin_rsyslog::params::logsrvloadtcp
        $srvport = $::admin_rsyslog::params::logsrvportinput
        
        # create a directory for remote logs
        
        file ( $::admin_rsyslog::params::logsrvremotepath ) {
            ensure => directory,
        	 owner => 'root',
	 	     group => 'adm',
		      mode => '0755',
        }
        
        # TODO: add template or rule to save diffrent hosts to diff files
        
    
    } else {
    
        $sendtohost = $::admin_rsyslog::params::sendtologhost
        $srvloadtcp = "#$::admin_rsyslog::params::logsrvloadtcp"
        $srvport = "#$::admin_rsyslog::params::logsrvportinput"
    
    }
    
    file { '/etc/rsyslog.conf':
        content => template( '/admin_rsyslog/rsyslog.conf.erb' ),
          owner => 'root',
          group => 'root',
        require => Class["admin_rsyslog::install"],
         notify => Class["admin_rsyslog::service"],
    }
    
    
    
    
    file { '/root/bin/rsyslog.test':
         source => "puppet:///modules/admin_rsyslog/rsyslog.test",
          owner => 'root',
          group => 'root',
           mode => '0700',
        require => Class["admin_rsyslog::install"],
    }  
    
}