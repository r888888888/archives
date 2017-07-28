class PoolVersions < ActiveRecord::Migration[5.0]
	def up
	  create_table "pool_versions", :force => true do |t|
	    t.integer  "booru_id", :null => false
	    t.integer  "pool_id", :null => false
	    t.integer  "post_ids", :array => true, :default => [], :null => false
	    t.integer  "added_post_ids", :array => true, :default => [], :null => false
	    t.integer  "removed_post_ids", :array => true, :default => [], :null => false
	    t.integer  "updater_id"
	    t.inet     "updater_ip_addr", :limit => nil
	    t.text     "description"
	    t.boolean  "description_changed", :default => false, :null => false
	    t.text     "name"
	    t.boolean  "name_changed", :default => false, :null => false
	    t.datetime "created_at"
	    t.datetime "updated_at"
	    t.integer  "version", :default => 1, :null => false
	    t.boolean  "is_active", :boolean, :default => true, :null => false
	    t.boolean  "is_deleted", :boolean, :default => false, :null => false
	    t.string   "category"
	  end

	  add_index "pool_versions", ["booru_id", "pool_id"], :name => "index_pool_versions_on_pool_id"
	  add_index "pool_versions", ["booru_id", "updater_id"], :name => "index_pool_versions_on_updater_id"
	  add_index "pool_versions", ["booru_id", "updater_ip_addr"], :name => "index_pool_versions_on_updater_ip_addr"
	end

	def down
		drop_table "pool_versions"
	end
end
