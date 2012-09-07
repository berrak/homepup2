#
# Configure logrotate. 
#
class admin_logrotate::config {

    # facter

    $mydomain = $::domain

    file { '/etc/logrotate.conf':
        owner => 'root',
        group => 'root',
        content =>  template('admin_logrotate/logrotate.conf.erb'),
        require => Class["admin_logrotate::install"],
    }
    
    # snippets go into the /logrotate.d
    
    file { '/etc/logrotate.d/rsyslog':
        owner => 'root',
        group => 'root',
        content =>  template('admin_logrotate/logrotate.erb'),
        require => Class["admin_logrotate::install"],
    }
    
}