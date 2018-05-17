mysqldump
=========

A Puppet module for managing mysqldump and mysqldump-based cronified backups

# Module usage

Typical usage:

    include ::mysqldump
    
    ::mysqldump::backup { 'daily':
        mysql_user             => 'database_user,
        mysql_passwd           => 'database_user_password',
        databases              => [ 'database_name' ],
        mysqldump_extra_params => '--lock-tables',
        hour                   => '4',
        minute                 => '50',
        weekday                => '*',
        email                  => 'monitor@example.org',
    }

For details see [init.pp](manifests/init.pp) and 
[backup.pp](manifests/backup.pp).
