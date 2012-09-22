##
## Configuration of chkrootkit
##
class puppet_chkrootkit::config {

    file { "/etc/chkrootkit.conf":
         source => "puppet:///modules/puppet_chkrootkit/chkrootkit.conf",
          owner => 'root',
          group => 'root',
        require => Package["chkrootkit"],
    }

}