#
# Class admin_cron installs 'root' cron jobs

#
class admin_cron {
    
    package { 'cron' :
        ensure => installed,
    }
    
    
}