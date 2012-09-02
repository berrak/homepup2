##
## site.pp
##

$extlookup_datadir = "/etc/puppet/files"
$extlookup_precedence = ["fstab_sda1_uuid"]

import "users/*"
import 'home.tld.pp'

