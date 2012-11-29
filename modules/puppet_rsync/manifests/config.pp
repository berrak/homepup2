##
## Backup user data with rsync
##
class puppet_rsync::config {

    include puppet_rsync::params
    
    $myhost = $::hostname
    $securefile = $::puppet_rsync::params::secretsfile
    $rsyncsrvaddress = $::puppet_rsync::params::rsync_server_address
    
    define srv_create_hostdirectory( $username='' ) {
    
        file { "/srv/backup/$name":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup"],
        }
        
        file { "/srv/backup/${name}/${username}":
         ensure => "directory",
          owner => 'root',
          group => 'root',
           mode => '0700',
        require => File["/srv/backup/${name}"],
        }      

        file { "/srv/backup/${name}/${username}/home":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup/${name}/${username}"],
        }
    
        # special case - if host and user exports NFS then we need backup sub directory for nfs on server
        
        if ( $name == $::puppet_rsync::params::nfs_host_for_rsync ) and ( $username == $::puppet_rsync::params::nfs_user_for_rsync ) {
        
            file { "/srv/backup/${name}/${username}/nfs":
                ensure => "directory",
                 owner => 'root',
                 group => 'root',
                  mode => '0700',
               require => File["/srv/backup/${name}/${username}"],
            }
        
        }

        
    }

    # simple rsync test scrip for the rsync server and clients
    
    file { '/root/bin/rsync.selftest':
        content =>  template('puppet_rsync/rsync.selftest.erb'),
          owner => 'root',
          group => 'root',
           mode => '0700',
        require => Class["puppet_rsync::install"],
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
        
        
        # create server directories for each desktop host/user that use rsync for backup
        
        srv_create_hostdirectory { "shire": username => 'bekr'}
        srv_create_hostdirectory { "shire": username => 'dakr'}
        
        srv_create_hostdirectory { "mordor": username => 'bekr'}
            
        
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
        
        # modified 'lightdm.conf' which will launch 'rsync.backup' at GUI-login 

        file { '/etc/lightdm/lightdm.conf' :
                 source =>  "puppet:///modules/puppet_rsync/lightdm.conf",
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
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