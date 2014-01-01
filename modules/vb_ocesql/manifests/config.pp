#
# Config OpenCobol Embedded SQL Precompiler
#
class vb_ocesql::config {

    
    
    # in addition set environment export LD_LIBRARY_PATH=/usr/local/lib'
    # (but that may not always working - e.g in SuExec env)
    
    # ensure that Ocesql finds its shared libraries at run
    # time (in case local admin installed it in /usr/local/lib).
    
    exec { "Install_Ocesql_symbolic_link_to_local_libraries" :
        cwd => "/usr/lib",
        command => "/bin/ln -s /usr/local/lib/libocesql.so.0.0.0 libocesql.so.0",
        onlyif => "/usr/bin/test -f /usr/local/lib/libocesql.so.0.0.0",
        creates => "/usr/lib/libocesql.so.0",
    }
     
}