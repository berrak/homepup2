##
## Backup user data with rsync
##
class puppet_rsync::config {

    include puppet_rsync::params
    
    $myhost = $::hostname
    $securefile = $::puppet_rsync::params::secretsfile
    $rsyncsrvaddress = $::puppet_rsync::params::rsync_server_address
    
    define srv_create_hostdirectory() {
    
        file { "/srv/backup/$name":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup"],
        }
    }
    
    if $::hostname == $::puppet_rsync::params::rsync_server_hostname {
    
        # create /srv/backup directory only for root's eyes
        
        file { "/srv/backup":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => Class["puppet_rsync::install"],
        }  
        
        # create directories for each desktop host that use rsync for backup
        
        $hostlist = $::puppet_rsync::params::hostlist_for_rsync
        srv_create_hostdirectory { $hostlist: }
        
        
        # old code below
        
        $backupfromhost = $::puppet_rsync::params::nfs_host_for_rsync
        $authuser1 = $::puppet_rsync::params::authuser1
        
        # main backup directory for authuser1
        
        file { "/srv/backup/${backupfromhost}/${authuser1}":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup/${backupfromhost}"],
        }      
        
        # directory for other individual home and sub directories (not nfs) 
        
        file { "/srv/backup/${backupfromhost}/${authuser1}/nfs":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup/${backupfromhost}/${authuser1}"],
        }               
        
        
        # directory for other individual home and sub directories (not nfs) 
        
        file { "/srv/backup/${backupfromhost}/${authuser1}/home":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup/${backupfromhost}/${authuser1}"],
        }            
        
        
        
        # default options for 'rsyncd'
        
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
    
        # rsync server: create our site rsync athorization file (change password!)
        
        file { "$securefile" :
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
   
        # rsync client: backup script for unprivileged users. This
        # also requires that <user>.backup exists in user the
        # ~/bin sub directory (installed for GUI (lightdm) users)
        
        file { '/usr/local/bin/rsync.backup' :
            content =>  template('puppet_rsync/rsync.backup.erb'),
              owner => 'root',
              group => 'staff',
               mode => '0700',
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
            
            # root cron job which lookup the exclude list here.

            file { "/root/bin/rsync-backup.excludes" :
                 source => "puppet:///modules/puppet_rsync/rsync-backup.excludes",    
                  owner => 'root',
                  group => 'root',
                   mode => '0600',
                require => Class["puppet_rsync::install"],
            } 
            
            # root cron job which lookup the passwd here.
            
            file { "$securefile" :
                 source => "puppet:///modules/puppet_rsync/rsyncd.pwd",    
                  owner => 'root',
                  group => 'root',
                   mode => '0600',
                require => Class["puppet_rsync::install"],
            }
            
        }
        
    
    }

}