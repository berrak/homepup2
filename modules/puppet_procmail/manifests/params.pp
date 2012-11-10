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
    # Note: update also the recipie template!
    
    $hostsubscriptionfolders = [ 'GONDOR', 'CARBON', 'VALHALL', 'MORDOR', 'ASGARD', 'SHIRE', 'WARP', '2012__SYSTEM_EVENTS__' , '2012__SECURITY_VIOLATIONS__', '2012__INTRUSION_ATTEMPTS__', '2013__SYSTEM_EVENTS__' , '2013__SECURITY_VIOLATIONS__', '2013__INTRUSION_ATTEMPTS__', '2012__BLOCKED__', '2013__BLOCKED__', '2014__BLOCKED__',  '2015__BLOCKED__', '2016__BLOCKED__', '2017__BLOCKED__', '2018__BLOCKED__', '2019__BLOCKED__', '2020__BLOCKED__', '2021__BLOCKED__','2022__BLOCKED__', '2023__BLOCKED__', '2024__BLOCKED__',  '2025__BLOCKED__', '2026__BLOCKED__', '2027__BLOCKED__', '2028__BLOCKED__', '2029__BLOCKED__', '2030__BLOCKED__', '2031__BLOCKED__', '2032__BLOCKED__' ]

}