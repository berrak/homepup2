#
# Configure rsyslog with template file. 
#
class admin_rsyslog::config {

    file { '/etc/rsyslog.conf':
        owner => 'root',
        group => 'root',
        content => template("admin_rsyslog/rsyslog.conf.erb"),
        require => Class["admin_rsyslog::install"],
        notify => Class["admin_rsyslog::service"],
    }
    
}