require 'dotenv'
Dotenv.load

require './models/post_version'

ActiveRecord::Base.record_timestamps = false

candidates = PostVersion.where("updated_at > '2017-04-09'").pluck(:post_id).uniq
candidates.each do |post_id|
  v = 1
  PostVersion.where(post_id: post_id).order("updated_at").each do |version|
    previous = PostVersion.find_previous(post_id, version.updated_at)
    version.version = v
    if previous
      version.rating_changed = version.rating != previous.rating
      version.parent_changed = version.parent_id != previous.parent_id
      version.added_tags = version.tag_array - previous.tag_array
      version.removed_tags = previous.tag_array - version.tag_array
    else
      version.added_tags = version.tag_array
      version.removed_tags = []
    end
    version.save
    v += 1
  end
end
