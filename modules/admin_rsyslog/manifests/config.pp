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
        
        
        # use cron to update any new hosts and their remote log files on loghost
        
        file { '/etc/cron.d/remoteloghostupdate':
             source => "puppet:///modules/admin_rsyslog/remoteloghostupdate",
              owner => 'root',
              group => 'root',
               mode => '0644',
            require => File["/root/jobs/cron.update_remote_log_directories"],
        }       
        
        # this script add logs to logcheck to scan, and make sure files get rotated
        
        file { '/root/jobs/cron.update_remote_log_directories':
             source => "puppet:///modules/admin_rsyslog/cron.update_remote_log_directories",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["$logcheckfilepath"],
        }
		
		# ensure that the directory referred by above script exist
		
        file { "/var/log/REMOTELOGS" :
            ensure => directory,
        	 owner => 'root',
	 	     group => 'adm',
		      mode => '0750',
           require => Class["admin_rsyslog::install"],              
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