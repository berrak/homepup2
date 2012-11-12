#
# Install the rsyslog package.
#
class admin_rsyslog::install {

    package { 'rsyslog':
        ensure => installed,
    }
    
    package { 'rsyslog-doc' :
         ensure => installed,
        require => Package["rsyslog"],
    }
    
    
    # TLS for rsyslog
    
    package { 'rsyslog-gnutls' :
         ensure => installed,
        require => Package["rsyslog"],
    }
    
}