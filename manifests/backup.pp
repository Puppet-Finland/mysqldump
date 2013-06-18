#
# == Define: mysqldump::backup
#
# Dump mysql databases to a directory using mysqldump and compress them using 
# gzip. New dumps overwrite the old ones, the idea being that a backup 
# application (e.g. rsnapshot or bacula) fetches the latest local backups at 
# regular intervals and no local versioning is thus necessary.
# 
# This define depends on the 'localbackups' class. Also, the 'mysql' class has 
# to be included or this define won't be found.
#
# == Parameters
#
# [*status*]
#   Status of the backup job. Either 'present' or 'absent'. Defaults to 
#   'present'.
# [*databases*]
#   Space-separated list of databases to back up. Defaults to 'all', which 
#   is a special parameter to dump all databases.
# [*output_dir*]
#   The directory where to output the files. Defaults to /var/backups/local.
# [*mysql_user*]
#   MySQL user with rights to dump the specified databases. Defaults to 'root'.
# [*mysql_passwd*]
#   Password for the above user.
# [*mysqldump_extra_params*]
#   Extra parameters to pass to mysqldump. Defaults to --lock-tables, which 
#   works for MyISAM tables. For InnoDB tables --single-transaction is more 
#   appropriate.
# [*hour*]
#   Hour(s) when the agent gets run. Defaults to * (all hours).
# [*minute*]
#   Minute(s) when the agent gets run. Defaults to 50.
# [*weekday*]
#   Weekday(s) when the agent gets run. Defaults to * (all weekdays).
#
# == Examples
#
# mysqldump::backup { 'trac_database':
#   mysql_user => 'trac',
#   mysql_passwd => 'dummy',
#   databases => 'trac',
#   mysqldump_extra_params => '--single-transaction',
# }
#
define mysqldump::backup
(
    $status = 'present',
    $databases = 'all',
    $output_dir = '/var/backups/local',
    $mysql_user = 'root',
    $mysql_passwd,
    $mysqldump_extra_params = '--lock-tables',
    $hour = '4',
    $minute = '15',
    $weekday = '*',
)
{

    include mysqldump

    if $databases == 'all' {
        $cron_command = "mysqldump -u${mysql_user} -p${mysql_password} --routines --all-databases ${mysqldump_extra_params}|gzip > ${output_dir}/all_databases.sql.gz"
    } else {
        $cron_command = "mysqldump -u${mysql_user} -p${mysql_password} --routines --databases ${databases} ${mysqldump_extra_params}|gzip > ${output_dir}/databases.sql.gz"
    }

    cron { "mysql-backup-${databases}-cron":
        ensure => $status,
        command => $cron_command,
        user => root,
        hour => $hour,
        minute => $minute,
        weekday => $weekday,
        require => Class['localbackups'],
    }
}
