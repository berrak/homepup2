#
# Manage postfix module parameters.
#
class puppet_komodoide6::params {

     
    # Note: These binaries files are are not in git 
    # repositories but copied to the /etc/puppet/files manually.
    
    # The file locations were all Komodo IDE install files are stored.
    $komodoide6_source_filepath = '/etc/puppet/files/komodo-ide6'
    
    $targzfile_i386 = 'Komodo-IDE-6.1.3-66534-linux-libcpp6-x86.tar.gz'
    $targzfile_amd64 = 'Komodo-IDE-6.1.3-66534-linux-libcpp6-x86_64.tar.gz'
    
    $exec_amd64 = 'Komodo-IDE-6-Linux-x86_64-S677BFB4CB44.executable'
    $exec_i386 = 'Komodo-IDE-6-Linux-x86-S677BFB4CB44.executable'
    

}