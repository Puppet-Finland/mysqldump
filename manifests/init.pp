#
# == Class: mysqldump
#
# Class to setup and configure mysqldump. Currently only exists so that 
# mysqldump::backup defines can be created. Separation of this class from the 
# mysql class allows management of mysqldump backups, while keeping mysql 
# management separate.
#
# == Parameters
#
# None at the moment
#
# == Examples
#
# include mysqldump
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class mysqldump {

    # This class does nothing at the moment.

}
