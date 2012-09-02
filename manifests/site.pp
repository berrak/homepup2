##
## site.pp
##
$extlookup_datadir = "/etc/puppet/files/"

import "users/*"
import 'home.tld.pp'

