##
## CLI tool to convert Git flavor of markdown to HTML
##
class puppet_git_md::install {

    package { [ "libjson-ruby" ] :
         ensure => installed
    }
    
}