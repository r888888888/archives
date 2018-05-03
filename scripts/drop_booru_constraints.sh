#!/bin/sh

psql db_archive_development -c 'alter table post_versions alter column booru_id drop not null'
psql db_archive_development -c 'alter table pool_versions alter column booru_id drop not null'
psql db_archive_test -c 'alter table post_versions alter column booru_id drop not null'
psql db_archive_test -c 'alter table pool_versions alter column booru_id drop not null'
