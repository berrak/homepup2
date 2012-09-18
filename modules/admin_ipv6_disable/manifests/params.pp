##
## Defines parameters for grub.erb
##
class admin_ipv6_disable::params {

    $mygrubcmdline = 'ipv6.disable=1'
    
    
    # this sets vga mode to 1024x768x16 to get more text on the server console
    $myvgaline = 'vga=791'
    $myvgahost = 'rohan'


}