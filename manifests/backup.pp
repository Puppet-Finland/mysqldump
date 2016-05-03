#
# == Define: mysqldump::backup
#
# Dump mysql databases to a directory using mysqldump and compress them using 
# gzip. New dumps overwrite the old ones, the idea being that a backup 
# application (e.g. rsnapshot or bacula) fetches the latest local backups at 
# regular intervals and no local versioning is thus necessary.
# 
# This define depends on the 'localbackups' class. Also, the 'mysqldump' class 
# has to be included or this define won't be found.
#
# == Parameters
#
# [*ensure*]
#   Status of the backup job. Either 'present' or 'absent'. Defaults to 
#   'present'.
# [*databases*]
#   A string or an array containing the names of the database(s) to back up. 
#   Defaults the resource $title. Use 'all' to back up all databases.
# [*output_dir*]
#   The directory where to output the files. Defaults to '/var/backups/local'.
# [*mysql_user*]
#   MySQL user with rights to dump the specified databases. Defaults to 'root'.
# [*mysql_passwd*]
#   Password for the above user.
# [*use_root_defaults*]
#   Defines whether to load /root/.my.cnf or not. This is intended to help 
#   prevent mysql passwords from leaking out in cron's emails if mysqldump 
#   errors out for whatever reason. Set this parameter to true to use this 
#   feature and make sure that /root/.my.cnf exists on the target nodes (e.g. by 
#   including the mysql::config::rootopts class). The default value is false, 
#   which means that the $mysql_user and $mysql_passwd will be used for 
#   authentication.
# [*mysqldump_extra_params*]
#   Extra parameters to pass to mysqldump. Defaults to '--lock-tables', which 
#   works for MyISAM tables. For InnoDB tables '--single-transaction' is more 
#   appropriate.
# [*hour*]
#   Hour(s) when mysqldump gets run. String or Integer. Defaults to '01'.
# [*minute*]
#   Minute(s) when mysqldump gets run. String or Integer. Defaults to '10'.
# [*weekday*]
#   Weekday(s) when mysqldump gets run. String or Integer. Defaults to '*' (all 
#   weekdays).
# [*email*]
#   Email address where notifications are sent. Defaults to top-scope variable
#   $::servermonitor.
#
# == Examples
#
#   mysqldump::backup { 'trac_database':
#       mysql_user => 'trac',
#       mysql_passwd => 'dummy',
#       databases => 'trac',
#       mysqldump_extra_params => '--single-transaction',
#   }
#
define mysqldump::backup
(
    Enum['present','absent'] $ensure = 'present',
    Variant[String, Array]   $databases = $title,
    String                   $output_dir = '/var/backups/local',
    Optional[String]         $mysql_user = 'root',
    Optional[String]         $mysql_passwd = undef,
    Boolean                  $use_root_defaults = false,
    Optional[String]         $mysqldump_extra_params = '--lock-tables',
    Variant[String, Integer] $hour = '01',
    Variant[String, Integer] $minute = '10',
    Variant[String, Integer] $weekday = '*',
    String                   $email = $::servermonitor
)
{
    include ::mysqldump
    include ::mysqldump::params

    if $databases.is_array {
        # Get string representations of the database array
        $databases_string = join($databases, ' ')
        $databases_identifier = join($databases, '_and_')
    } else {
        $databases_string = $databases
        $databases_identifier = $databases
    }

    if $use_root_defaults {
        $auth_string = '--defaults-extra-file=/root/.my.cnf'
    } else {
        $auth_string = "-u${mysql_user} -p\"${mysql_passwd}\""
    }

    if $databases_string == 'all' {
        $cron_command = "mysqldump ${auth_string} --routines --all-databases ${mysqldump_extra_params}|gzip > \"${output_dir}/all-databases-full.sql.gz\""
    } else {
        $cron_command = "mysqldump ${auth_string} --routines --databases ${databases_string} ${mysqldump_extra_params}|gzip > \"${output_dir}/${databases_identifier}-full.sql.gz\""
    }

    cron { "mysqldump-backup-${databases_identifier}-cron":
        ensure      => $ensure,
        command     => $cron_command,
        user        => $::os::params::adminuser,
        hour        => $hour,
        minute      => $minute,
        weekday     => $weekday,
        require     => Class['localbackups'],
        environment => [ 'PATH=/bin:/usr/bin:/usr/local/bin', "MAILTO=${email}" ],
    }
}
