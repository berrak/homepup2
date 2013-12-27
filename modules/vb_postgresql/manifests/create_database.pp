#
# Manage PostgreSQL-9.1
#
# Sample usage: vb_postgresql::create_database { 'openjensen' : databaseowner => 'jensen', databaseuser => 'bekr' }
#
#
define vb_postgresql::create_database ( $databaseowner='', $databaseuser='' ) {

    include vb_postgresql

	if $databaseowner == '' {
		fail("FAIL: Missing the new database owner name for the $name PostgreSQL database!")
	}
	
	if $databaseuser == '' {
		fail("FAIL: Missing the new database regular user name for the $name PostgreSQL database!")
	}		
		
	# create database (and owner) and users
	
    file { "/var/lib/postgresql/create_database_${name}.sql":
		content =>  template( "vb_postgresql/create_database_${name}.sql.erb" ),
          owner => 'postgres',
          group => 'postgres',
		  mode  => '0644',
        require => Class["vb_postgresql::install"],
    }	
	
	exec { "create_postgres_database_${name}":
		command => "/usr/bin/psql -f /var/lib/postgresql/create_database_${name}.sql",
		user => 'postgres',
		subscribe => File["/var/lib/postgresql/create_database_${name}.sql"],
		refreshonly => true,
		require => File["/var/lib/postgresql/create_database_${name}.sql"],
	}		

	
}