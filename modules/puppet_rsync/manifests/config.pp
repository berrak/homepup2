##
## Backup user data with rsync
##
class puppet_rsync::config {

    include puppet_rsync::params
    
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
        
        file { "/srv/backup/${backupfromhost}":
             ensure => "directory",
              owner => 'root',
              group => 'root',
               mode => '0700',
            require => File["/srv/backup"],
        }
        
        # distribution is 'wheezy'
        
        $debdistribution = $::puppet_rsync::params::deb_rsync_distribution
        
        exec { "make_backup_directory_${backupfromhost}":
            command => "/bin/mkdir -p /srv/backup/${backupfromhost}/${debdistribution}",
            subscribe => File["/srv/backup/${backupfromhost}"],
            refreshonly => true,
        }
        
        # default options for 'rsyncd' (at server)
        
        $rsyncsrvaddress = $::puppet_rsync::params::rsync_server_address
        
        file { '/etc/default/rsync':
            content =>  template('puppet_rsync/rsync.erb'),
              owner => 'root',
              group => 'root',
               mode => '0644',
            require => Class["puppet_rsync::install"],
             notify => Class["puppet_rsync::service"],
        }
        
        
        # configuration for rsync
        
        $securefile = $::puppet_rsync::params::secretsfile
        $authusers = $::puppet_rsync::params::authuserlist
        $hostallowip = $::puppet_rsync::params::hostallowip
        
        file { '/etc/rsyncd.conf':
            content =>  template('puppet_rsync/rsyncd.conf.erb'),
              owner => 'root',
              group => 'root',
               mode => '0600',
            require => Class["puppet_rsync::install"],
             notify => Class["puppet_rsync::service"],
        }    
    
        # create our athorization file (!! change passwd to more secure !!)
        
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
        
    }

}