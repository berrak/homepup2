#
# Configure rsyslog. 
#
class admin_rsyslog::config {

    file { '/etc/rsyslog.conf':
        owner => 'root',
        group => 'root',
        source => "puppet:///modules/admin_rsyslog/rsyslog.conf",
        require => Class["admin_rsyslog::install"],
        notify => Class["admin_rsyslog::service"],
    }
    
}