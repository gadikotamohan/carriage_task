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

ActiveRecord::Schema.define(version: 2019_02_15_075415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "authentications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "provider"
    t.string "uid"
    t.hstore "credentials"
    t.datetime "expires_at"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.integer "comments_count", default: 0
    t.uuid "list_id"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_cards_on_list_id"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.uuid "user_id"
    t.uuid "parent_id"
    t.uuid "resource_id"
    t.string "resource_type"
    t.integer "replies_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "lists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0
  end

  create_table "lists_users", id: false, force: :cascade do |t|
    t.uuid "list_id", null: false
    t.uuid "user_id", null: false
    t.index ["list_id", "user_id"], name: "index_lists_users_on_list_id_and_user_id", unique: true
    t.index ["user_id", "list_id"], name: "index_lists_users_on_user_id_and_list_id", unique: true
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "authentication_id"
    t.string "token"
    t.datetime "expires_at"
    t.string "device_id"
    t.string "client_name"
    t.string "client_version"
    t.string "app_version"
    t.index ["authentication_id"], name: "index_sessions_on_authentication_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0
    t.jsonb "profile", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lists_count", default: 0
  end

  add_foreign_key "authentications", "users"
  add_foreign_key "cards", "lists"
  add_foreign_key "cards", "users"
  add_foreign_key "comments", "comments", column: "parent_id", name: "parent_id_comment_id"
  add_foreign_key "comments", "users"
  add_foreign_key "sessions", "authentications"
  add_foreign_key "sessions", "users"
end
