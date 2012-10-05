##
## Class to manage virtual system users 
## (accounts), i.e. not human users.
##
class virtual_accounts {

    @user { "nobody" :
        ensure => present,
           uid => '65534',
           gid => 'nogroup',
          home => '',
         shell => '/bin/false',
    }

}