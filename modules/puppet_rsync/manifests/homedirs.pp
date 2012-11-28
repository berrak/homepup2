#
# Define to create subdirectories for individual
# user directories at the rsync backup server
#
define puppet_rsync::homedirs ( $hostdir='' ) {
    
    include puppet_rsync::params

    file { "/srv/backup/${hostdir}/${name}":
         ensure => "directory",
          owner => 'root',
          group => 'root',
           mode => '0700',
        require => File["/srv/backup/${hostdir}"],
    }      

    file { "/srv/backup/${hostdir}/${name}/home":
         ensure => "directory",
          owner => 'root',
          group => 'root',
           mode => '0700',
        require => File["/srv/backup/${hostdir}/${name}"],
    }
    
    # special case - if host and user exports NFS then we need backup sub directory for nfs on server
    
    if ( $hostdir == $::puppet_rsync::params::nfs_host_for_rsync ) and ( $name == $::puppet_rsync::params::nfs_user_for_rsync ) {
    
        file { "/srv/backup/${hostdir}/${name}/nfs":
            ensure => "directory",
             owner => 'root',
             group => 'root',
              mode => '0700',
           require => File["/srv/backup/${hostdir}/${name}"],
        }
    
    }
    

} 