##
## Hardening a host. Each subclass corresponds to
## script in tiger, i.e. ::system <--> check_system
## otherwise hardening is done in ::cis
##
class admin_hardening {

    include admin_hardening::system, admin_hardening::accounts

}