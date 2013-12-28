#
# Manage PostgreSQL-9.1
#
class vb_postgresql::params {

    # define the encoding scheme for a new database, ISO8859-15 (LATIN9) is fine for sweden
    
    $database_encoding = "ENCODING='LATIN9' LC_COLLATE='sv_SE.885915' LC_CTYPE='sv_SE.885915' "
    
    # UTF-8 does not work well with OpenCobol ESQL library 1.0.0
    # $database_encoding = "ENCODING='UTF8' LC_COLLATE='sv_SE.utf8' LC_CTYPE='sv_SE.utf8' "

}
