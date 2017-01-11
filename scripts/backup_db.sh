#!/bin/bash

PGOPTIONS="-c statement_timeout=0" pg_dump -Fc -f ~archiver/pg_archive_backups/archive_production-`date +"%Y-%m-%d-%H-%M"`.dump archive_production
