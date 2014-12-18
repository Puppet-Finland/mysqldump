#
# == Class: mysqldump
#
# Class for setting up mysqldump and optionally configuring cronjobs that back 
# up database using it.
#
# This class is separated from the mysql class for two reasons:
#
# - In some environments managing backups using Puppet is desirable, but 
#   managing mysql configuration using Puppet is not an option.
# - The presence of mysqldump does not necessarily mean that there's a mysql 
#   server on the same host.
#
# Note that this module requires puppet stdlib:
#
# <https://forge.puppetlabs.com/puppetlabs/stdlib>
#
# == Parameters
#
# [*backups*]
#   A hash of mysql::backup resources to realize.
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
class mysqldump
(
    $backups = {}
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_mysqldump', 'true') != 'false' {

    # Realize the defined backup jobs
    create_resources('mysqldump::backup', $backups)

}
}
