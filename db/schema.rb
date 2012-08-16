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

ActiveRecord::Schema.define(:version => 20120814011747) do

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
    t.integer  "office_id"
    t.integer  "user_id"
    t.integer  "article_type",         :default => 1
    t.boolean  "has_front_page_image", :default => false
    t.integer  "article_category_id"
    t.boolean  "is_deleted",           :default => false
    t.datetime "publication_datetime"
    t.datetime "datetime"
    t.boolean  "is_displayed",         :default => false
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "assignments", :force => true do |t|
    t.integer  "role_id"
    t.integer  "job_attachment_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "clients", :force => true do |t|
    t.integer  "office_id"
    t.integer  "creator_id"
    t.string   "name"
    t.text     "address"
    t.string   "mobile"
    t.string   "home_phone"
    t.string   "bb_pin"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contact_reports", :force => true do |t|
    t.integer  "office_id"
    t.integer  "user_id"
    t.integer  "client_id"
    t.integer  "project_id"
    t.integer  "contact_purpose",  :default => 0
    t.string   "summary"
    t.text     "description"
    t.datetime "contact_datetime"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "deliverable_items", :force => true do |t|
    t.integer  "project_id"
    t.integer  "deliverable_id"
    t.integer  "sub_item_quantity"
    t.text     "project_specific_description"
    t.boolean  "is_started",                   :default => false
    t.text     "supplier_info"
    t.integer  "starter_id"
    t.date     "start_date"
    t.boolean  "is_finished",                  :default => false
    t.integer  "finisher_id"
    t.date     "finish_date"
    t.boolean  "is_delivered",                 :default => false
    t.integer  "deliverer_id"
    t.date     "delivery_date"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "deliverable_subcriptions", :force => true do |t|
    t.integer  "package_id"
    t.integer  "deliverable_id"
    t.integer  "package_specific_sub_item_quantity"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "deliverables", :force => true do |t|
    t.integer  "office_id"
    t.string   "name"
    t.text     "description"
    t.string   "sub_item_name"
    t.boolean  "has_sub_item",                                              :default => false
    t.integer  "sub_item_quantity"
    t.decimal  "independent_price",          :precision => 11, :scale => 2, :default => 0.0
    t.decimal  "independent_sub_item_price", :precision => 11, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
  end

  create_table "drafts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "important_events", :force => true do |t|
    t.date     "event_date"
    t.string   "title"
    t.text     "description"
    t.boolean  "is_repeating_annually", :default => false
    t.integer  "creator_id"
    t.integer  "client_id"
    t.integer  "yday"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "job_attachments", :force => true do |t|
    t.integer  "office_id"
    t.integer  "user_id"
    t.boolean  "is_active",  :default => false
    t.boolean  "is_deleted", :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "job_requests", :force => true do |t|
    t.integer  "source_id"
    t.integer  "office_id"
    t.string   "source_type"
    t.integer  "project_id"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "job_request_source", :default => 1
    t.date     "starting_date"
    t.date     "ending_date"
    t.integer  "number_of_days"
    t.integer  "yday"
    t.integer  "year"
    t.boolean  "is_canceled",        :default => false
    t.integer  "canceller_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "offices", :force => true do |t|
    t.string   "name"
    t.integer  "main_user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "package_assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "package_id"
    t.decimal  "price",      :precision => 11, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "packages", :force => true do |t|
    t.integer  "office_id"
    t.string   "name"
    t.text     "description"
    t.decimal  "base_price",               :precision => 12, :scale => 2, :default => 0.0
    t.boolean  "is_crew_specific_pricing",                                :default => false
    t.integer  "number_of_crew",                                          :default => 1
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
  end

  create_table "project_assignments", :force => true do |t|
    t.integer  "project_membership_id"
    t.integer  "project_role_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "project_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.integer  "package_id"
    t.integer  "sales_order_id"
    t.string   "title"
    t.text     "project_guideline"
    t.date     "shoot_date"
    t.date     "starting_date"
    t.date     "ending_date"
    t.string   "shoot_location"
    t.boolean  "is_started",                  :default => false
    t.boolean  "is_supply_finished",          :default => false
    t.boolean  "is_pre_production_finished",  :default => false
    t.boolean  "is_production_finished",      :default => false
    t.boolean  "is_post_production_finished", :default => false
    t.boolean  "is_finished",                 :default => false
    t.integer  "selected_pro_crew_id"
    t.integer  "creator_id"
    t.integer  "client_id"
    t.boolean  "is_canceled",                 :default => false
    t.integer  "canceller_id"
    t.integer  "office_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sales_orders", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "client_id"
    t.decimal  "total_transaction_amount", :precision => 11, :scale => 2, :default => 0.0
    t.boolean  "is_down_payment_paid",                                    :default => false
    t.decimal  "down_payment_amount",      :precision => 11, :scale => 2, :default => 0.0
    t.boolean  "is_confirmed",                                            :default => false
    t.integer  "confirmer_id"
    t.boolean  "is_canceled",                                             :default => false
    t.integer  "canceller_id"
    t.string   "title"
    t.text     "description"
    t.integer  "office_id"
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
  end

  create_table "tasks", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
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
