#
# Manage PostgreSQL-9.1
#
# Sample usage: vb_postgresql::add_dbuser { 'openjensen' : databaseuser => 'bekr' }
#
#
define vb_postgresql::add_dbuser ( $databaseuser='' ) {

	
	include vb_postgresql
	
	if $databaseuser == '' {
		fail("FAIL: Missing the new database user name for the $name PostgreSQL database!")
	}	
	
		
	# add one database user
	
    file { "/var/lib/postgresql/add_${databaseuser}_to_database.sql":
		content =>  template( "vb_postgresql/add_${databaseuser}_to_database.sql.erb" ),
          owner => 'postgres',
          group => 'postgres',
		  mode  => '0644',
        require => Class["vb_postgresql::install"],
    }	
	
	exec { "create_postgres_user_${databaseuser}":
		command => "/usr/bin/psql -f /var/lib/postgresql/add_${databaseuser}_to_database.sql",
		user => 'postgres',
		subscribe => File["/var/lib/postgresql/add_${databaseuser}_to_database.sql"],
		refreshonly => true,
		require => File["/var/lib/postgresql/add_${databaseuser}_to_database.sql"],
	}		
    
}