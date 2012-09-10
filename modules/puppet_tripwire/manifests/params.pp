#
# Manage tripwire module parameters.
#
class puppet_tripwire::params {

    # The file location were all preseed files are stored.
    # In this case the 'tripwire.preseed' file.
    
    $preseedfilepath = "/etc/puppet/files/tripwire.preseed"
    
    # tripwire configuration file (twcfg.txt)
    
    # do not use host.domain unless real DNS server on local network.
    # 'localhost' is fine  (postfix is cfg to relay all mails to relay host).
    
    $mylocalhost = 'localhost'
    $smtphost_fqdn = $mylocalhost
    
    $editorpath = '/bin/nano'

}