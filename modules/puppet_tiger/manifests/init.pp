##
## Class to manage tiger (report system security vulnerabilities)
##
class puppet_tiger {

    include puppet_tiger::install, puppet_tiger::config, puppet_tiger::params

}