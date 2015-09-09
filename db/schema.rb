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

ActiveRecord::Schema.define(version: 20150909162949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_owners", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "owner_id"
    t.string   "owner_type", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "article_owners", ["article_id"], name: "index_article_owners_on_article_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.string   "title",                  limit: 255,                   null: false
    t.text     "content",                                              null: false
    t.integer  "creator_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "top_story"
    t.integer  "newsletter_id"
    t.integer  "position_in_newsletter"
    t.string   "status",                 limit: 255, default: "draft"
    t.text     "author_content"
    t.text     "summary",                                              null: false
    t.integer  "home_page_order"
    t.datetime "date_published"
    t.integer  "category_id",                                          null: false
  end

  add_index "articles", ["category_id"], name: "index_articles_on_category_id", using: :btree
  add_index "articles", ["creator_id"], name: "index_articles_on_creator_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "full_name",  limit: 255, null: false
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "category_newsletters", force: :cascade do |t|
    t.integer "category_id"
    t.integer "newsletter_id"
    t.integer "position_in_newsletter"
  end

  add_index "category_newsletters", ["category_id"], name: "index_category_newsletters_on_category_id", using: :btree
  add_index "category_newsletters", ["newsletter_id"], name: "index_category_newsletters_on_newsletter_id", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "cover_images", force: :cascade do |t|
    t.string   "cover_photo_file_name",    limit: 255
    t.string   "cover_photo_content_type", limit: 255
    t.integer  "cover_photo_file_size"
    t.datetime "cover_photo_updated_at"
    t.integer  "article_id"
    t.boolean  "preview_image",                        default: false
  end

  add_index "cover_images", ["article_id"], name: "index_cover_images_on_article_id", using: :btree

  create_table "create_article_owners", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "owner_id"
    t.string   "owner_type", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "create_article_owners", ["article_id"], name: "index_create_article_owners_on_article_id", using: :btree
  add_index "create_article_owners", ["owner_id"], name: "index_create_article_owners_on_owner_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "newsletters", force: :cascade do |t|
    t.string   "name",           limit: 255,                   null: false
    t.string   "status",         limit: 255, default: "draft"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.datetime "date_published"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: ""
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "uid",                    limit: 255
    t.string   "provider",               limit: 255
    t.string   "first_name",             limit: 255,              null: false
    t.string   "last_name",              limit: 255,              null: false
    t.integer  "year_of_birth"
    t.string   "country",                limit: 255
    t.string   "gender",                 limit: 255
    t.string   "type",                   limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "article_owners", "articles"
  add_foreign_key "articles", "categories"
  add_foreign_key "category_newsletters", "categories"
  add_foreign_key "category_newsletters", "newsletters"
  add_foreign_key "cover_images", "articles"
  add_foreign_key "create_article_owners", "articles"
end
