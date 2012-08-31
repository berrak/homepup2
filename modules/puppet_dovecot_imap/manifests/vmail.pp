#
# Create virtual user vmail.
#
class puppet_dovecot_imap::vmail {

    # create vmail virtual dovecot mailuser
    
    realize( Group["vmail"] )
    realize( User["vmail"] )

}