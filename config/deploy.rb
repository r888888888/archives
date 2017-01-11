set :application, "archives"
set :repo_url, "git://github.com/r888888888/archives.git"
set :deploy_to, "/var/www/archives"
set :scm, :git
set :rbenv_type, :user
set :rbenv_ruby, "2.3.1"
set :linked_files, fetch(:linked_files, []).push(".env")
