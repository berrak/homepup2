node basenode {

}


node 'carbon.home.tld' inherits basenode {

	include puppet_master
    # puppet_devtools::tools { 'bekr' : }

}
