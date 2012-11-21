##
## Class cron-apt
##
class admin_cronapt::install {

    package { "cron-apt":
        ensure => installed,
    }

}