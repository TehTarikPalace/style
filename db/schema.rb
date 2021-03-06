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

ActiveRecord::Schema.define(version: 20151103070740) do

  create_table "stat_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stat_headers", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.integer  "stat_category_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "stat_headers", ["stat_category_id"], name: "index_stat_headers_on_stat_category_id"

  create_table "studio_connections", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "oracle_host"
    t.string   "oracle_instance"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "port"
  end

  create_table "studio_indices", force: :cascade do |t|
    t.string   "server"
    t.string   "share"
    t.string   "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username"
    t.string   "password"
    t.string   "workgroup"
    t.string   "caption"
  end

  create_table "user_credentials", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "studio_connection_id"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "user_credentials", ["studio_connection_id"], name: "index_user_credentials_on_studio_connection_id"
  add_index "user_credentials", ["user_id"], name: "index_user_credentials_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "domain"
    t.string   "name"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
