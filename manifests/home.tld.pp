node basenode {

    include admin_home

}


node 'carbon.home.tld' inherits basenode {

	include puppet_master
    # puppet_devtools::tools { 'bekr' : }

}

node 'gondor.home.tld' inherits basenode {

	include puppet_agent
    

}
