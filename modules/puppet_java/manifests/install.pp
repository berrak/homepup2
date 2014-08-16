#
# Oracle Java JDK8 update/install
#
class puppet_java::install {

    # List required deb's for install/update script in /files directory
    package { "gawk" : ensure => installed }

}