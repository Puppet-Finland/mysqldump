#
# == Class: mysqldump
#
# Class to setup and configure mysqldump. Currently only exists so that 
# mysqldump::backup defines can be created. Separation of this class from the 
# mysql class allows management of mysqldump backups, while keeping mysql 
# management separate.
#
# This module requires puppet stdlib:
#
# <https://forge.puppetlabs.com/puppetlabs/stdlib>
#
# == Parameters
#
# None at the moment
#
# == Examples
#
#    include mysqldump
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class mysqldump {

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_mysqldump', 'true') != 'false' {

    # This class does nothing at the moment.
}
}
