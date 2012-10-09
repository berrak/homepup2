#
# Class to manage procmail filtering at mailserver
#
class puppet_procmail {

    include puppet_procmail::install, puppet_procmail::config, puppet_procmail::params

}