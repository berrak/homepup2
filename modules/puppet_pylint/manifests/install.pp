#
# Install Python Lint checker
#
class puppet_pylint::install {

    package { "pylint" : ensure => installed }

}