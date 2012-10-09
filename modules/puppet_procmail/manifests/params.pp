#
# procmail parameters
#
class puppet_procmail::params {

    # set which host is the mail server
    $mailserver_hostname = 'rohan'
    
    # our admin user (which will receive all local domain roots mails)
    $rootmailuser = 'bekr'
    
    # all mail user accounts
    $mailuserlist = ['bekr', 'dakr']
    

}