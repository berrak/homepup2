##
## Manage project source build (i.e. with make)
##
class le_build {

    include puppet_komodo_devsetup::project, puppet_komodo_devsetup::make, puppet_komodo_devsetup::params

}