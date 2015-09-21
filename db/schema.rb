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

ActiveRecord::Schema.define(version: 20150921071917) do

  create_table "repo_header_stats", force: :cascade do |t|
    t.integer  "repository_id"
    t.integer  "repo_stat_id"
    t.integer  "stat_header_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "repo_header_stats", ["repo_stat_id"], name: "index_repo_header_stats_on_repo_stat_id"
  add_index "repo_header_stats", ["repository_id"], name: "index_repo_header_stats_on_repository_id"
  add_index "repo_header_stats", ["stat_header_id"], name: "index_repo_header_stats_on_stat_header_id"

  create_table "repo_stats", force: :cascade do |t|
    t.integer  "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.integer  "studio_connection_id_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "repositories", ["studio_connection_id_id"], name: "index_repositories_on_studio_connection_id_id"

  create_table "stat_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stat_headers", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.integer  "repo_stat_id_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "stat_headers", ["repo_stat_id_id"], name: "index_stat_headers_on_repo_stat_id_id"

  create_table "studio_connections", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.string   "oracle_host"
    t.string   "oracle_instance"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "port"
  end

end
