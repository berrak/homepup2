##
## Configure global client git user name/email/editor etc.
##
## Note:
##     On server depot must the git user/group 'project1', 'project2' exist
##     exist and client users have their keys in that user 
##      '~/.ssh/authorized_keys' file. Keys does not require passwords.
##     Keys is only used for authentication and encryption.
##
## Sample use:
##
##     puppet_git::config { 'bekr' : }
##
define puppet_gitclient::config {

    include puppet_gitclient::install
    
    if ( $name == 'bkron' ) {
	
	    $mygitname = 'bkron'
		$mygitemail = 'bkron@cpan.org'
		
	} elsif (( $name == 'bekr' ) and ( $::hostname == 'carbon' )) {

		# host carbon is for 'puppet code'
	
		$mygitname = 'berrak'
		$mygitemail = 'bkronmailbox-git@yahoo.se'	
	
	} elsif ( $name == 'bekr' ) {
	
		# all other hosts are normal development
		
		$mygitname = 'debinix'
		$mygitemail = 'bertil.kronlund@gmail.com'  
		
	} else {
	
		fail("FAIL: Unknow user ($name). Please add user!")
	}

    $mygiteditor = '/bin/nano'
    $mylogformat = '%Cred%h%Creset -%C(Yellow)%d%Creset%s%Cgreen(%cr) %C(bold blue)<%an>%Creset'
	    
    file { "/home/${name}/.gitconfig" :
          content =>  template( 'puppet_gitclient/gitconfig.erb' ),
            owner => $name,
            group => $name,
          require => Package["git"],
    }
    	
	# user git bashrc snippet
	
	file { "/home/${name}/bashrc.d/git.rc" :
		ensure => present,
		source => "puppet:///modules/puppet_gitclient/git.rc",
		 owner => $name,
		 group => $name,
	}
    
}
