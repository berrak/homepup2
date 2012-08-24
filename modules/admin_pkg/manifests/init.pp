##
## This class use apt negativ pin priority to ensure a
## package that is black listed can be installed.
##
class admin_pkg {

    include admin_pkg::blacklist

}