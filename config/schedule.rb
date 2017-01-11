every "0 1 * * *" do
	command "bash -l -c 'cd /var/www/archives/current && scripts/backup_db.sh'"
end

every "0 2 * * *" do
	command "bash -l -c 'cd /var/www/archives/current && bundle exec ruby scripts/backup_db_to_s3.rb'"
end

every "0 3 * * *" do
	command "bash -l -c 'cd /var/www/archives/current && scripts/prune_backup_dbs.sh'"
end
