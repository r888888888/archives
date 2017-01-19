# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170119015012) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pool_versions", force: :cascade do |t|
    t.integer  "pool_id",                             null: false
    t.integer  "post_ids",            default: [],    null: false, array: true
    t.integer  "added_post_ids",      default: [],    null: false, array: true
    t.integer  "removed_post_ids",    default: [],    null: false, array: true
    t.integer  "updater_id"
    t.inet     "updater_ip_addr"
    t.text     "description"
    t.boolean  "description_changed", default: false, null: false
    t.text     "name"
    t.boolean  "name_changed",        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",             default: 1,     null: false
    t.boolean  "is_active",           default: true,  null: false
    t.boolean  "boolean",             default: false, null: false
    t.boolean  "is_deleted",          default: false, null: false
    t.string   "category"
    t.index ["pool_id"], name: "index_pool_versions_on_pool_id", using: :btree
    t.index ["updater_id"], name: "index_pool_versions_on_updater_id", using: :btree
    t.index ["updater_ip_addr"], name: "index_pool_versions_on_updater_ip_addr", using: :btree
  end

  create_table "post_versions", force: :cascade do |t|
    t.integer  "post_id",                                   null: false
    t.text     "tags",                                      null: false
    t.text     "added_tags",                default: [],    null: false, array: true
    t.text     "removed_tags",              default: [],    null: false, array: true
    t.integer  "updater_id"
    t.inet     "updater_ip_addr",                           null: false
    t.datetime "updated_at",                                null: false
    t.string   "rating",          limit: 1
    t.boolean  "rating_changed",            default: false, null: false
    t.integer  "parent_id"
    t.boolean  "parent_changed",            default: false, null: false
    t.text     "source"
    t.boolean  "source_changed",            default: false, null: false
    t.integer  "version",                   default: 1,     null: false
    t.index ["post_id"], name: "index_post_versions_on_post_id", using: :btree
    t.index ["updated_at"], name: "index_post_versions_on_updated_at", using: :btree
    t.index ["updater_id"], name: "index_post_versions_on_updater_id", using: :btree
    t.index ["updater_ip_addr"], name: "index_post_versions_on_updater_ip_addr", using: :btree
  end

end
