##
## Manage virtual accounts
##
class user::virtual {

    @user { "git1" :
        ensure => present,
         shell => '/usr/bin/git-shell',
        system => false,
    }

}