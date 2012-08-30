##
## Class to manage virtual groups. 
##
class virtual_groups {

    # used for dovecot.

    @group { "vmail" :
        ensure => present,
           gid => '2000',
    }

}