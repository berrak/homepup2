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
			
	# create database and owner
	
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
	
	# add another user. (Note that this user still must be granted access to each
	# table and other database objects before having free acess to owners database)

	if $databaseuser != '' {
		
		file { "/var/lib/postgresql/add_database_${name}_user_${databaseuser}.sql":
			content =>  template( "vb_postgresql/add_database_${name}_user_${databaseuser}.sql.erb" ),
			  owner => 'postgres',
			  group => 'postgres',
			  mode  => '0644',
			require => Class["vb_postgresql::install"],
		}	
		
		exec { "add_postgres_user_${databaseuser}_to_database_${name}":
			command => "/usr/bin/psql -f /var/lib/postgresql/add_database_${name}_user_${databaseuser}.sql",
			user => 'postgres',
			subscribe => File["/var/lib/postgresql/add_database_${name}_user_${databaseuser}.sql"],
			refreshonly => true,
			require => File["/var/lib/postgresql/add_database_${name}_user_${databaseuser}.sql"],
		}		
		
	}	



	
}