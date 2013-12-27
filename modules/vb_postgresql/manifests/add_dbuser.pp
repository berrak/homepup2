#
# Manage PostgreSQL-9.1
#
# Sample usage: vb_postgresql::add_dbuser { 'bekr' : }
#
#
define vb_postgresql::add_dbuser {

	
	include vb_postgresql
		
	# add one database user
	
    file { '/var/lib/postgresql/create_user_${name}.sql':
         source => "puppet:///modules/vb_postgresql/create_user_${name}.sql",    
          owner => 'postgres',
          group => 'postgres',
		  mode  => '0644',
        require => Class["vb_postgresql::install"],
    }	
	
	exec { "create_postgres_user":
		command => "/usr/bin/psql -f /var/lib/postgresql/create_user_${name}.sql",
		user => 'postgres',
		subscribe => File["/var/lib/postgresql/create_user_${name}.sql"],
		refreshonly => true,
	}	
	
	# although the user password may not be in use, it should always have mode '0600'
	
    #exec { "set_mode_password_file" :
    #     command => "/bin/chmod 0600 /home/$name/.pgpass",    
    #}
	
	
    
}