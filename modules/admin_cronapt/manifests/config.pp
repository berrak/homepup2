##
## Class cron-apt
##
class admin_cronapt::config {


    file { "/etc/cron-apt/config":
         source => "puppet:///modules/admin_cronapt/config",
          owner => 'root',
          group => 'root',
           mode => '0640',
        require => Package["cron-apt"],
    }
    
    file { "/etc/cron-apt/action.d/0-update":
         source => "puppet:///modules/admin_cronapt/0-update",
          owner => 'root',
          group => 'root',
           mode => '0644',
        require => Package["cron-apt"],
    }  
    
    file { "/etc/cron-apt/action.d/3-download":
         source => "puppet:///modules/admin_cronapt/3-download",
          owner => 'root',
          group => 'root',
           mode => '0644',
        require => Package["cron-apt"],
    }     


    # install our cron job
    
    file { "/etc/cron.d/cron-apt":
         source => "puppet:///modules/admin_cronapt/cron-apt",
          owner => 'root',
          group => 'root',
           mode => '0644',
        require => Package["cron-apt"],
    }      
    


}