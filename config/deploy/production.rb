set :rails_env, "production"

server "oumae.donmai.us", :user => "archiver", :roles => %w(web app db)
