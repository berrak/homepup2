#
# Install the rsyslog package.
#
class admin_rsyslog::install {

    package { 'rsyslog' :
        ensure => installed,
    }
    
}