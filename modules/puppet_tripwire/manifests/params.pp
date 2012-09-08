#
# Manage tripwire module parameters.
#
class puppet_tripwire::params {

    # The file location were all preseed files are stored.
    # In this case the 'tripwire.preseed' file.
    
    $preseedfilepath = "/etc/puppet/files/tripwire.preseed"
    
    # tripwire configuration file (twcfg.txt)
    
    $smtphost_name = 'rohan'
    $editorpath = '/bin/nano'

}