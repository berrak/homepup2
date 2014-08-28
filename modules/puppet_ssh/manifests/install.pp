##
## puppet_ssh manage openssh server and clients.
##
class puppet_ssh::install {
    
	    package { "openssh-client": ensure => installed }
        package { "openssh-server": ensure => installed }
        
}