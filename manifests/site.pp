##
## site.pp
##
$extlookup_datadir = "/etc/puppet/files"
$extlookup_precedence = ["carbon"]

import "users/*"
import 'home.tld.pp'

