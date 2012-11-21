##
## Configuration of chkrootkit
##
class puppet_chkrootkit::config {

    file { "/etc/chkrootkit.conf":
         source => "puppet:///modules/puppet_chkrootkit/chkrootkit.conf",
          owner => 'root',
          group => 'root',
        require => Package["chkrootkit"],
    }
    
    # Original maintainer start script (from cron.daily) to /root/bin
    
    file { "/bin/root/chkrootkit.sh":
         source => "puppet:///modules/puppet_chkrootkit/chkrootkit.sh",
          owner => 'root',
          group => 'root',
           mode => '0700',
        require => Package["chkrootkit"],
    }
    
    # create a local admin scheduled cron job in cron.d
    
    file { '/etc/cron.d/chkrootkit' :
         source =>  "puppet:///modules/puppet_chkrootkit/chkrootkit",
          owner => 'root',
          group => 'root',
           mode => '0644',
		require => Package["chkrootkit"],           
    }
    
    
	# This is NON-executable file that prevents maintainer changes
	# or run-parts to execute a daily cron job (is now run in cron.d)
	
    file { '/etc/cron.daily/chkrootkit' :
         source =>  "puppet:///modules/puppet_chkrootkit/chkrootkit.dummy",
          owner => 'root',
          group => 'root',
           mode => '0644',
		require => Package["chkrootkit"],           
    }
    

}