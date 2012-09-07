#
# Start the rsyslog daemon.
#
class admin_rsyslog::service {

    service { 'rsyslog':
        ensure => running,
        enable => true,
        require => Class["admin_rsyslog::config"],
    }
}