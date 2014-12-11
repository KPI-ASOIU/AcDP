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

ActiveRecord::Schema.define(version: 20140606193609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "connected_to_users"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "checklists", force: true do |t|
    t.boolean  "done"
    t.string   "name"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "owner_id",         null: false
    t.integer  "commentable_id",   null: false
    t.string   "commentable_type", null: false
    t.text     "body",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.integer  "user_id"
    t.integer  "contact_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_has_types", force: true do |t|
    t.integer "document_type_id", null: false
    t.integer "document_id",      null: false
  end

  create_table "document_types", force: true do |t|
    t.string "title", limit: 45, null: false
  end

  create_table "documents", force: true do |t|
    t.integer  "parent_directory"
    t.integer  "doc_type",                                null: false
    t.integer  "owner_id",                                null: false
    t.datetime "date_created",                            null: false
    t.datetime "date_updated",                            null: false
    t.string   "title",            limit: 80,             null: false
    t.string   "description"
    t.string   "tags"
    t.integer  "for_roles",                   default: 0, null: false
    t.integer  "original_doc_id"
  end

  create_table "documents_news_posts", id: false, force: true do |t|
    t.integer "document_id"
    t.integer "news_post_id"
  end

  create_table "event_has_guests", force: true do |t|
    t.integer "event_id"
    t.integer "guest_id"
    t.integer "status",   default: 1
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "date"
    t.string   "place"
    t.text     "plan"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
  end

  create_table "executing_tasks_executors", force: true do |t|
    t.integer "task_id"
    t.integer "executor_id"
  end

  create_table "file_infos", force: true do |t|
    t.integer  "document_id",       null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
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

  create_table "groups_news_posts", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "news_post_id"
  end

  create_table "messages", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "author_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_posts", force: true do |t|
    t.string   "title",             null: false
    t.text     "content",           null: false
    t.string   "tags"
    t.integer  "creator_id",        null: false
    t.integer  "for_roles",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "student_infos", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
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

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "end_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "user_has_accesses", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "document_id", null: false
    t.integer  "access_type", null: false
    t.datetime "created_at",  null: false
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
