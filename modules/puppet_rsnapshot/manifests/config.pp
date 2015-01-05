##
## Backup user data with rsnapshot
##
class puppet_rsnapshot::config {

    ## modified 'lightdm.conf' to launch perl script i.e.  
    ## 'backup_to_user_nfs.pl' when user login via GUI(LXDE)
    
    file { '/etc/lightdm/lightdm.conf' :
             source =>  "puppet:///modules/puppet_rsnapshot/lightdm.conf",
              owner => 'root',
              group => 'root',
               mode => '0644',
            require => Package["rsnapshot"],    
    }
    
    file { '/usr/local/bin/backup_to_user_nfs.sh' :
         source =>  "puppet:///modules/puppet_rsnapshot/backup_to_user_nfs.sh",        
          owner => 'root',
          group => 'staff',
           mode => '0555',
        require => Package["rsnapshot"], 
    }
    
    # ensure original global cron-job is not used
    file { "/etc/cron.d/rsnapshot":
        ensure => absent,
    }
    
}
