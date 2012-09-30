##
## Class to handle networking (Debian).
## Curently supports 'static' addresses.
##
class puppet_network {

    include puppet_network::interfaces, puppet_network::kernel, puppet_network::service, puppet_network::params
    
}