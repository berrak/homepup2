#
# Module to manage one central postfix lan server mta and many
# satellite mta's. Only interlan mails are allowed.
#
class puppet_postfix {

    # no need to include ('puppet_postfix::install' - defines are auto loaded)
    include puppet_postfix::params

}