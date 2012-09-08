#
# Manage tripwire (integrity application)
#
class puppet_tripwire {

    include puppet_tripwire::params, puppet_tripwire::tools, puppet_tripwire::cron, puppet_tripwire::config

    # this is a define and autoloaded when called

    puppet_tripwire::install { "tripwire" : ensure => installed }

}