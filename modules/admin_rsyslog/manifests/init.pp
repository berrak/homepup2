#
# Manage 'rsyslog' 
#
class admin_rsyslog {

    include admin_rsyslog::install, admin_rsyslog::config, admin_rsyslog::params, admin_rsyslog::service

}