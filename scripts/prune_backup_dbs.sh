#!/bin/bash

find /home/archiver/pg_archive_backups -name 'archive_production-*.dump' -mtime +1 -exec /bin/rm -f {} \;
