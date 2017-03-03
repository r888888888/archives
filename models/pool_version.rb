require 'active_record'
require 'active_support/core_ext/numeric/time'

class PoolVersion < ActiveRecord::Base
  establish_connection(
    adapter: "postgresql",
    host: ENV["POSTGRES_HOST"],
    database: ENV["POSTGRES_DB"],
    username: ENV["POSTGRES_USER"],
    password: ENV["POSTGRES_PASSWORD"],
    pool: 5
  )

  def self.find_previous(pool_id, updated_at)
    PoolVersion.where(pool_id: pool_id).where("updated_at < ?", updated_at).order("updated_at desc").first
  end

  def self.calculate_version(pool_id, updated_at)
    1 + PoolVersion.where(pool_id: pool_id).where("updated_at < ?", updated_at).count
  end

  def self.create_from_json(json)
    created_at = json["created_at"] ? Time.parse(json["created_at"]) : nil
    updated_at = json["updated_at"] ? Time.parse(json["updated_at"]) : created_at
    post_ids = json["post_ids"]
    previous = find_previous(json["pool_id"], updated_at)
    subject = PoolVersion.new
    subject.version = calculate_version(json["pool_id"], updated_at),

    if previous && previous.updater_id == json["updater_id"] && previous.updated_at >= 1.hour.ago
      subject = previous
      previous = find_previous(previous.pool_id, previous.updated_at)
    end

    if previous
      added_post_ids = post_ids - previous.post_ids
      removed_post_ids = previous.post_ids - post_ids
    else
      added_post_ids = post_ids
      removed_post_ids = []
    end

    description_changed = previous.nil? || json["description"] != previous.try(:description)
    name_changed = previous.nil? || json["name"] != previous.try(:name)
    attribs = {
      pool_id: json["pool_id"],
      post_ids: post_ids,
      added_post_ids: added_post_ids,
      removed_post_ids: removed_post_ids,
      updater_id: json["updater_id"],
      updater_ip_addr: json["updater_ip_addr"],
      description: json["description"],
      description_changed: description_changed,
      name: json["name"],
      name_changed: name_changed,
      created_at: created_at,
      updated_at: updated_at,
      is_active: json["is_active"],
      is_deleted: json["is_deleted"],
      category: json["category"]      
    }

    ActiveRecord::Base.record_timestamps = false
    subject.attributes = attribs
    subject.id = json["id"] if json["id"]
    subject.save
  ensure
    ActiveRecord::Base.record_timestamps = true
  end
end
