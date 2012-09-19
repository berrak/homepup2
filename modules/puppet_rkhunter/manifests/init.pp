##
## Rootkit Hunter scans systems for known and unknown
## rootkits, backdoors, sniffers and exploits. 
##
class puppet_rkhunter {

    include puppet_rkhunter::install, puppet_rkhunter::config, puppet_rkhunter::params

}