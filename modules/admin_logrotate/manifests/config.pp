#
# Configure logrotate. 
#
class admin_logrotate::config {

    # facter

    $mydomain = $::domain

    file { '/etc/logrotate.conf':
        content =>  template('admin_logrotate/logrotate.conf.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["admin_logrotate::install"],
    }
    
    # snippets go into the /logrotate.d
    
    file { '/etc/logrotate.d/rsyslog':
         source => "puppet:///modules/admin_logrotate/rsyslog",    
          owner => 'root',
          group => 'root',
        require => Class["admin_logrotate::install"],
    }
    
}