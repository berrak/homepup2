## mypup

### A puppetized home repo

I decided to share my puppet-usage to manage some systems.  I hope it will
evolve over time and get stable one day. My hope is that it helps someone to
get a kick-start into the puppet world and in particular to Debian Linux
administration.
I mainly use/test wheezy so I don't care much for other *nixes or so, but
the 12.04 version of Ubuntu should be pretty close.

Maybe I spend more time on admin tasks than on elegant puppet constructs but
I will try to adhere to Puppet Best Practices.

### Version information

Debian wheezy/sid (Linux kernel 3.2.0)

Puppet 2.7.18-1

Ruby1.9.3

### Installation of puppet on Debian (all is pulled in as dependencies)

I use wheezy/sid. To install the puppet master:

    # aptitude install puppetmaster
    
To install puppet agent on the nodes
    
    # aptitude install puppet


### Directory structure and puppet modules

I decided to focus much on modularization. I do not use
the top level templates directory but created a files sub
directory for Debian preseed files. The 'site.pp'
and the nodes file are in the manifests sub directory.

The layout structure is simply organized below /etc/puppet like so:

    /etc/puppet/manifests
                        site.pp
                        home.tld.pp
    
    /etc/puppet/files                    
                        .
                        <preseed-name/>
                        .
                        .
                                 
    /etc/puppet/modules                    
                        .
                        <module-name/>
                                    files/
                                    manifests/
                                    templates/
                        .
                        .

The configuration files are in the main /etc/puppet directory.

