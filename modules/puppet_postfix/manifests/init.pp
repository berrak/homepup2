#
# Module to manage one central postfix lan server mta and many
# satellite mta's. Only inter lan mails are allowed.
#
class puppet_postfix {

    include puppet_postfix::params, puppet_postfix::install, puppet_postfix::service

}