##
## Blacklist named package i.e. never allow it to be installed.
##
define admin_pkg::blacklist {
    
    $file = "/etc/apt/preferences.d/$name"
    $package = $name

    file { "$file" :
        ensure  => present, 
        owner   => 'root',
        group   => 'root',
        content => template("admin_pkg/preferences.d.erb"),
    }

}