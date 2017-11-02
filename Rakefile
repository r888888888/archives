require 'dotenv'
Dotenv.load ".env", "/run/secrets/archives_env"

require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

desc "Rebuild post version history"
task :rebuild_post_history do
	require './models/post_version'

  ActiveRecord::Base.record_timestamps = false
  candidate_post_ids = PostVersion.where("updated_at > ?", 30.days.ago).pluck("distinct post_id")

  candidate_post_ids.each do |post_id|
		previous = nil
		v = 1
		
		PostVersion.where(post_id: post_id).order("updated_at").each do |version|
			if previous
				added_tags = version.tag_array - previous.tag_array
				removed_tags = previous.tag_array - version.tag_array
			else
				added_tags = version.tag_array
				removed_tags = []
			end

			version.update_attributes(added_tags: added_tags, removed_tags: removed_tags, version: v)

			previous = version
			v += 1
		end
	end

  ActiveRecord::Base.record_timestamps = true
end
