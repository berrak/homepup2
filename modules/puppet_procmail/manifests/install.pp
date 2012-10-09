#
# procmail parameters
#
class puppet_procmail::install {

    include puppet_procmail::params

    # only install procmail on the mail server host
    
    if $::hostname == $::puppet_procmail::params::mailserver_hostname {
    
        package { "procmail":
             ensure => installed,
        }
        
    }

}