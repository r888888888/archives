#!/bin/sh

psql archive_development -c 'alter table post_versions alter column booru_id drop not null'
psql archive_development -c 'alter table pool_versions alter column booru_id drop not null'
psql archive_test -c 'alter table post_versions alter column booru_id drop not null'
psql archive_test -c 'alter table pool_versions alter column booru_id drop not null'
