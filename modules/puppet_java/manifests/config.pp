#
# Oracle Java JDK8 update/install
#
class puppet_java::config {

	# Bash script to manage install and updates from Oracles Java website
	
	file { "/root/bin/check-oracle-java":
		 source => "puppet:///modules/puppet_java/check-oracle-java",
          owner => 'root',
          group => 'root',
		   mode => '0755',
	}
    
	# Cron job to run script weekly for updates
	
	file { "/etc/cron.weekly/oracle-java":
		 source => "puppet:///modules/puppet_java/oracle-java",
          owner => 'root',
          group => 'root',
		   mode => '0755',
	}
    
}