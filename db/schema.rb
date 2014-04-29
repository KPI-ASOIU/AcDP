# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140425183204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversations", force: true do |t|
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "executing_tasks_executors", force: true do |t|
    t.integer "task_id"
    t.integer "executor_id"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "start_year"
    t.integer  "graduation_year"
    t.boolean  "full_time",       default: true
    t.integer  "degree",          default: 1
    t.string   "speciality"
    t.string   "speciality_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.integer  "unread_messages_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_has_tags", force: true do |t|
    t.integer "task_id"
    t.integer "tag_id"
  end

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "end_date"
    t.string   "status"
    t.text     "check_list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login",                         default: "", null: false
    t.string   "encrypted_password",            default: "", null: false
    t.integer  "role",                limit: 2, default: 1,  null: false
    t.string   "full_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "position",                      default: "", null: false
    t.text     "about_me",                      default: "", null: false
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
