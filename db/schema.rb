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

ActiveRecord::Schema.define(version: 2019_02_14_114950) do

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

  create_table "lists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "authentication_id"
    t.string "token"
    t.datetime "expires_at"
    t.string "device_id"
    t.string "client_name"
    t.string "client_version"
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
  add_foreign_key "lists", "users"
  add_foreign_key "sessions", "authentications"
  add_foreign_key "sessions", "users"
end
