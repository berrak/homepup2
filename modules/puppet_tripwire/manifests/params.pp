#
# Manage tripwire module parameters.
#
class puppet_tripwire::params {

    # The file location were all preseed files are stored.
    # In this case the 'tripwire.preseed' file.
    
    $preseedfilepath = "/etc/puppet/files/tripwire.preseed"
    
    
    
    ## tripwire configuration file (twcfg.txt)
    ## smtphost can be fqdn if DNS is available.
    
    $smtphost = '192.168.0.11'
    $editorpath = '/bin/nano'
    
    # avoid to use generic temporary directory '/tmp'
    $twtmpdirectory = '/var/lib/tripwire/tmp'
    
    
    ## tripwire policy file (twpol.txt)
    
    $mailto = 'root@home.tld'
    
    
    

    


}