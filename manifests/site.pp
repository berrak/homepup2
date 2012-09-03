##
## site.pp
##
$extlookup_precedence = ["fstab_sda1_uuid"]
$extlookup_datadir = "/etc/puppet/files"

import "users/*"
import 'home.tld.pp'

