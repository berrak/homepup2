##
## puppet_ssh manage openssh server and clients.
##
class puppet_ssh::config {
    
        file { "/root/.ssh":
            ensure => "directory",
             owner => 'root',
             group => 'root',
              mode => '0700',
	    }
        
        #  This script will append the public host key (id_rsa.pub) to
        #  this host and user '~/.ssh/authorized_keys' file. This helper
        #  is used by 'ssh.cpkey' script when a remote clients sends
        #  its 'id_rsa.pub' file and is therfore automaticall invoked. 
        
        file { "/root/bin/ssh.addkey" :
                source => "puppet:///modules/puppet_ssh/ssh.addkey",
                 owner => 'root',
                 group => 'root',
                  mode => '0700',
        }	 

}