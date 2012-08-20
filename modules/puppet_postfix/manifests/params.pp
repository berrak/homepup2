#
# Manage postfix module parameters.
#
class puppet_postfix::params {

    # The file location were all preseed files are stored.
    # In this case the '{server|satellite}.postfix.preseed' file.
    
    $server_preseedfilepath = "/etc/puppet/files/server.postfix.preseed"
    $satellite_preseedfilepath = "/etc/puppet/files/satellite.postfix.preseed"


}