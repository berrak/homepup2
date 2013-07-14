#
# Module to prepare the Komodo IDE 6 at clients. After puppet run,
# run the the extracted install.sh script and run the license
# installer to complete the set-up.
#
class puppet_komodoide6 {

    include puppet_komodoide6::params, puppet_komodoide6::install

}