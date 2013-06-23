#
# Manage apache2
#
class puppet_apache::config {

    # Global security settings
    
    file { '/etc/apache2/conf.d/security':
         source => "puppet:///modules/puppet_apache/security",    
          owner => 'root',
          group => 'root',
        require => Class["puppet_apache::install"],
        notify => Service["apache2"],
    }

    file { '/etc/apache2/ports.conf':
        content =>  template('puppet_apache/ports.conf.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["puppet_apache::install"],
        notify => Service["apache2"],
    }
    
    ## Configure the default vhost (catch all for an unmatched site)
    
    $wwwipaddress = $::ipaddress
    
    file { '/etc/apache2/sites-available/default':
        content =>  template('puppet_apache/default.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["puppet_apache::install"],
    }

    ## Enable the default vhost site
    
    file { '/etc/apache2/sites-enabled/000-default':
        ensure => 'link',
        target => '/etc/apache2/sites-available/default',
       require => Class["puppet_apache::install"],
    }
    
    ## Configure the localhost vhost (catch all for an unmatched site)
    
    $localhostaddress = '127.0.0.1'
    
    file { '/etc/apache2/sites-available/localhost':
        content =>  template('puppet_apache/localhost.erb'),
          owner => 'root',
          group => 'root',       
        require => Class["puppet_apache::install"],
    }

    ## Enable the localhost vhost site
    
    file { '/etc/apache2/sites-enabled/000-localhost':
        ensure => 'link',
        target => '/etc/apache2/sites-available/localhost',
       require => Class["puppet_apache::install"],
    }
    
    
	# Create the directory for the default and localhost vhost site
    
	file { "/var/www/www.default.tld":
		ensure => "directory",
		owner => 'root',
		group => 'root',
		mode => '0755',
	}
    
    # Default and localhost index file
    
    file { '/var/www/www.default.tld/index.html':
         source => "puppet:///modules/puppet_apache/default.index.html",    
          owner => 'root',
          group => 'root',
        require => File["/var/www/www.default.tld"],
    }
    
}