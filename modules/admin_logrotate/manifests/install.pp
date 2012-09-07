#
# Install the logrotate package (if not already installed default)
#
class admin_logrotate::install {

    package { 'logrotate' :
        ensure => installed,
    }
    
}