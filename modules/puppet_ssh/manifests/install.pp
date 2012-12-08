##
## puppet_ssh manage openssh server and clients.
##
class puppet_ssh::install {

    include puppet_ssh::params
    
    if $::hostname == $::puppet_ssh::params::sshserverhostname {
    
        package { "openssh-server": ensure => installed }
        
        file { "/root/.ssh":
            ensure => "directory",
             owner => 'root,
             group => 'root',
              mode => '0700',
	    }
    
    } else {
    
        package { "openssh-client": ensure => installed }
    
    }
    
}