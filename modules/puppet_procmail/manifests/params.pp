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
    
    # list for the dovecot/imap 'subscriptions' folders 
    # (capatilized) to match the folders names in recipes.rc.
    # Do not include the mail server host here. Local mails
    # is routed by default to top .INBOX by 'procmail'.
    
    $hostsubscriptionfolders = [ 'GONDOR', 'CARBON', 'VALHALL', 'MORDOR', 'ASGARD', 'SHIRE' ]

}