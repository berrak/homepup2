##
## Backup user data with rsync
##
class puppet_rsync::config {

    include puppet_rsync::params
    
    $securefile = $::puppet_rsync::params::secretsfile
    
    if $::hostname == $::puppet_rsync::params::rsync_server_hostname {
    
        # create /srv/backup directory only for root's eyes
        
        file { "/srv/backup":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => Class["puppet_rsync::install"],
        }  
        
        # host is 'shire' and is the NFS data share for all desktop hosts
        
        $backupfromhost = $::puppet_rsync::params::nfs_host_for_rsync
        $authuser1 = $::puppet_rsync::params::authuser1
        
        file { "/srv/backup/${backupfromhost}":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup"],
        }
        
        file { "/srv/backup/${backupfromhost}/${authuser1}":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup/${backupfromhost}"],
        }      
        
        # default options for 'rsyncd' (at server, none is required at client)
        $rsyncsrvaddress = $::puppet_rsync::params::rsync_server_address
        
        file { '/etc/default/rsync':
            content =>  template('puppet_rsync/rsync.erb'),
              owner => 'root',
              group => 'root',
               mode => '0644',
            require => Class["puppet_rsync::install"],
             notify => Class["puppet_rsync::service"],
        }
        
        
        # configuration for rsync with 'some' security 
        
        $hostallowip = $::puppet_rsync::params::hostallowip
        
        file { '/etc/rsyncd.conf':
            content =>  template('puppet_rsync/rsyncd.conf.erb'),
              owner => 'root',
              group => 'root',
               mode => '0640',
            require => Class["puppet_rsync::install"],
             notify => Class["puppet_rsync::service"],
        }    
    
        # rsync server: create our rsync athorization file (change password!)
        
        file { $securefile :
             source => "puppet:///modules/puppet_rsync/rsyncd.pwd",    
              owner => 'root',
              group => 'root',
               mode => '0600',
            require => Class["puppet_rsync::install"],
        }
            
        # log rotation snippets go into the /logrotate.d
        
        file { '/etc/logrotate.d/rsync':
             source => "puppet:///modules/puppet_rsync/logrotate.conf.rsync",    
              owner => 'root',
              group => 'root',
               mode => '0644',
            require => Class["puppet_rsync::install"],
        }
        
        # create a local (warp) rsync directory for various tests
        
        file { "/srv/localrsync":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => Class["puppet_rsync::install"],
        }                
        
    } else {
   
        # rsync client: backup script for unprivileged users
        
        file { '/usr/local/bin/rsync-backup' :
             source => "puppet:///modules/puppet_rsync/rsync-backup",    
              owner => 'root',
              group => 'staff',
               mode => '0755',
            require => Class["puppet_rsync::install"],
        }        
        
        # rsync client: exclude file to the script for unprivileged users        
        
        file { "/usr/local/bin/rsync-backup.excludes" :
             source => "puppet:///modules/puppet_rsync/rsync-backup.excludes",    
              owner => 'root',
              group => 'staff',
               mode => '0644',
            require => Class["puppet_rsync::install"],
        }      
        
        # rsync client: create client host athorization file for unprivileged users
        
        file { $securefile :
             source => "puppet:///modules/puppet_rsync/rsyncd.pwd",    
              owner => 'root',
              group => 'root',
               mode => '0600',
            require => Class["puppet_rsync::install"],
        }
        
        # rsync client: create script to be run at user login
        # $home is our custom facter variable for environment $HOME.

        file { "$home/bin/rbackup" :
             source => "puppet:///modules/puppet_rsync/rbackup",    
               mode => '0755',
            require => Class["puppet_rsync::install"],
        }   
     
        # create a root cron backup job for the desktop host that acts as the 
        # desktops central repository and rsync that with remote rsync server.
        
        if $::hostname == $::puppet_rsync::params::nfs_host_for_rsync {
        
            file { '/etc/cron.d/rsyncshire' :
                 source =>  "puppet:///modules/puppet_rsync/rsyncshire",
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
                require => Class["puppet_rsync::install"],       
            }
        
        }
        
    
    }

}