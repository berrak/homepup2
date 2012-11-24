##
## site.pp
##
##

File { filebucket => none }

$extlookup_precedence = ["fstab_sda1_uuid"]
$extlookup_datadir = "/etc/puppet/files"

import "users/*"
import 'base.pp'
import 'servers.pp'
import 'gateways.pp'
import 'desktops.pp'

