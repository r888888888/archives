require 'active_record'
require 'active_support/core_ext/numeric/time'

class PostVersion < ActiveRecord::Base
  establish_connection(
    adapter: "postgresql",
    host: ENV["POSTGRES_HOST"],
    database: ENV["POSTGRES_DB"],
    username: ENV["POSTGRES_USER"],
    password: ENV["POSTGRES_PASSWORD"],
    pool: 5
  )

  def self.find_previous(post_id, updated_at)
    where("post_id = ? and updated_at < ?", post_id, updated_at).order("updated_at desc, id desc").first
  end

  def self.calculate_version(post_id, updated_at)
    1 + where("post_id = ? and updated_at < ?", post_id, updated_at).count
  end

  def self.create_from_json(json)
    created_at = json["created_at"] ? Time.parse(json["created_at"]) : nil
    updated_at = json["updated_at"] ? Time.parse(json["updated_at"]) : created_at
    tags = json["tags"].scan(/\S+/)
    previous = find_previous(json["post_id"], updated_at)
    subject = PostVersion.new

    if previous
      added_tags = tags - previous.tag_array
      removed_tags = previous.tag_array - tags
    else
      added_tags = tags
      removed_tags = []
    end

    rating_changed = previous.nil? || json["rating"] != previous.try(:rating)
    parent_changed = previous.nil? || json["parent_id"] != previous.try(:parent_id)
    source_changed = previous.nil? || json["source"] != previous.try(:source)
    attribs = {
      post_id: json["post_id"],
      tags: tags.join(" "),
      added_tags: added_tags,
      removed_tags: removed_tags,
      updater_id: json["updater_id"],
      updater_ip_addr: json["updater_ip_addr"],
      updated_at: updated_at,
      version: calculate_version(json["post_id"], updated_at),
      rating: json["rating"],
      rating_changed: rating_changed,
      parent_id: json["parent_id"],
      parent_changed: parent_changed,
      source: json["source"],
      source_changed: source_changed
    }

    ActiveRecord::Base.record_timestamps = false
    subject.attributes = attribs
    subject.id = json["id"] if json["id"]
    subject.save
  ensure
    ActiveRecord::Base.record_timestamps = true
  end

  def tag_array
    tags.scan(/\S+/)
  end
end