##
##
## This class manage the linux cups printing (if not installed).
##
class puppet_cups {

    include puppet_cups::install, puppet_cups::service

}