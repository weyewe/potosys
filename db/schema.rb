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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120719134413) do

  create_table "article_pictures", :force => true do |t|
    t.string   "name"
    t.integer  "article_id"
    t.string   "original_image_url"
    t.string   "article_image_url"
    t.string   "front_page_image_url"
    t.string   "index_image_url"
    t.integer  "original_image_size"
    t.integer  "article_image_size"
    t.integer  "front_page_image_size"
    t.integer  "index_image_size"
    t.integer  "article_display_order",      :default => 0
    t.boolean  "is_displayed",               :default => false
    t.boolean  "is_displayed_at_front_page", :default => false
    t.boolean  "is_displayed_as_teaser",     :default => false
    t.boolean  "is_deleted",                 :default => false
    t.integer  "article_picture_type",       :default => 1
    t.boolean  "is_completed",               :default => false
    t.text     "assembly_url"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "sub_title"
    t.text     "description"
    t.text     "teaser"
    t.integer  "project_id"
    t.integer  "company_id"
    t.integer  "user_id"
    t.integer  "article_type",         :default => 1
    t.boolean  "has_front_page_image", :default => false
    t.integer  "article_category_id"
    t.boolean  "is_deleted",           :default => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "assignments", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
