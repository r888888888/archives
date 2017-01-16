require 'dotenv'
Dotenv.load

require './models/pool_version'

ActiveRecord::Base.record_timestamps = false

candidates = PoolVersion.where("updated_at > '2017-01-01'").pluck(:pool_id)
candidates.each do |pool_id|
  v = 1
  PoolVersion.where(pool_id: pool_id).order("updated_at").each do |version|
    previous = PoolVersion.find_previous(pool_id, version.updated_at)
    version.version = v
    if previous
      version.added_post_ids = version.post_ids - previous.post_ids
      version.removed_post_ids = previous.post_ids - version.post_ids
    else
      version.added_post_ids = version.post_ids
      version.removed_post_ids = []
    end
    version.save
    v += 1
  end
end
