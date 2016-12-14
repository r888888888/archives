namespace :deploy do

  desc 'Runs rake db:migrate if migrations are set'
  task :migrate do
    on fetch(:migration_servers) do
      info '[deploy:migrate] Run `rake db:migrate`'
      invoke :'deploy:migrating'
    end
  end

  desc 'Runs rake db:migrate'
  task :migrating do
    on fetch(:migration_servers) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:migrate'
        end
      end
    end
  end

  after 'deploy:updated', 'deploy:migrate'
end

namespace :load do
  task :defaults do
    set :migration_role, fetch(:migration_role, :db)
    set :migration_servers, -> { primary(fetch(:migration_role)) }
  end
end
