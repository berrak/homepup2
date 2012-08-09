#
# Manage tripwire module parameters.
#
class puppet_tripwire::params {

    # The file location were all preseed files are stored.
    # In this case the 'tripwire.preseed' file.
    
    $preseedfilepath = "/etc/puppet/preseeds/tripwire.preseed"

}