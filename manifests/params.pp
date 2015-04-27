#
# == Class: mysqldump::params
#
# Set some variables according to the operating system
#
class mysqldump::params {

    include ::os::params
}
