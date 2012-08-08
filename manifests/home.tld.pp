node basenode {

    include admin_home

    admin_bndl::install { 'cliadminapps' : }

}


node 'carbon.home.tld' inherits basenode {

	include puppet_master
    # puppet_devtools::tools { 'bekr' : }
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }

}

node 'gondor.home.tld' inherits basenode {

	include puppet_agent
    

}
