##
## Parameters
##
class puppetize::params {

    $mypuppetserver_fqdn = 'carbon.home.tld'
    
    $mypuppetserver_hostname = 'carbon'
    
    # The alternate fqdn for the puppet client (client and master on same host)
    $mypuppetserverclient_node_fqdn = 'nodecarbon.home.tld'

}