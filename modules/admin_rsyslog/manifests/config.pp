#
# Configure rsyslog. 
#
class admin_rsyslog::config {

    include admin_rsyslog::params
    
    $myloghost = $::admin_rsyslog::params::myloghost
    
    if $::hostname == $myloghost {
     
        include admin_rsyslog::params
         
        # where logfiles are saved for logcheck scans
        $logcheckfilepath = $::admin_rsyslog::params::logcheckfilespath
        
        file { '/etc/rsyslog.conf':
            ensure  => present,
            content => template("admin_rsyslog/rsyslog.loghost.conf.erb"),            
            owner   => 'root',
            group   => 'root',
            require => Class["admin_rsyslog::install"],
             notify => Class["admin_rsyslog::service"],
        }
        
        
        # make sure that cron update any new host and their remote log files
        file { '/etc/cron.daily/remotelogupdate':
             source => "puppet:///modules/admin_rsyslog/remotelogupdate",
              owner => 'root',
              group => 'root',
               mode => '0755',
            require => File["/root/bin/cron.update_remote_log_directories"],
        }       
        
        # this script add logs to logcheck to scan, and make sure files get rotated
        
        file { '/root/bin/cron.update_remote_log_directories':
             source => "puppet:///modules/admin_rsyslog/cron.update_remote_log_directories",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["$logcheckfilepath"],
        }             
        
        # create a directory for all logs (local and remote) for 'logcheck' to
        # scan. Note: Need group to be 'adm' (since logcheck belongs to 'adm')
        
        file { "$logcheckfilepath" :
            ensure => directory,
        	 owner => 'root',
	 	     group => 'adm',
		      mode => '0750',
           require => Class["admin_rsyslog::install"],              
        }
        
        # write some notes to admin where we put syslog(.log) when using logcheck
        
        file { '/var/log/syslogforadmin.README':
             source => "puppet:///modules/admin_rsyslog/syslogforadmin.README",
              owner => 'root',
              group => 'root',
               mode => '0640',
           require => Class["admin_rsyslog::install"],    
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