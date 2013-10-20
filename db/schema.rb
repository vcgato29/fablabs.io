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

ActiveRecord::Schema.define(version: 20131018191113) do

  create_table "labs", force: true do |t|
    t.integer  "creator_id"
    t.string   "workflow_state"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.string   "avatar_src"
    t.string   "header_image_src"
    t.string   "phone"
    t.string   "email"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "address_3"
    t.string   "city"
    t.string   "county"
    t.string   "postal_code"
    t.string   "country_code"
    t.string   "subregion"
    t.string   "region"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "zoom"
    t.text     "address_notes"
    t.text     "application_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labs", ["creator_id"], name: "index_labs_on_creator_id"

  create_table "recoveries", force: true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recoveries", ["user_id"], name: "index_recoveries_on_user_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "users", force: true do |t|
    t.string   "workflow_state"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "avatar_src"
    t.string   "city"
    t.string   "country_code"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "url"
    t.date     "dob"
    t.text     "bio"
    t.string   "my_locale"
    t.string   "my_timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
