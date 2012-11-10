##
## Manage logserver remote received syslogs with 'logcheck'
##
class puppet_logcheck {

    include puppet_logcheck::install, puppet_logcheck::config, puppet_logcheck::params 

}