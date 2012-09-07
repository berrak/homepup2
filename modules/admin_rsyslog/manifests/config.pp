#
# Configure rsyslog with template file. 
#
class admin_rsyslog::config {

    file { '/etc/rsyslog.conf':
        owner => 'root',
        group => 'root',
        content => template("admin_rsyslog/rsyslog.conf.erb"),
        require => Class["rsyslog::install"],
        notify => Class["rsyslog::service"],
    }
    
}