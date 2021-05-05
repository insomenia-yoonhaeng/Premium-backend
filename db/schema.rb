# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_02_135816) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "tutee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.index ["project_id"], name: "index_attendances_on_project_id"
    t.index ["tutee_id"], name: "index_attendances_on_tutee_id"
  end

  create_table "auths", force: :cascade do |t|
    t.string "description"
    t.string "authable_type", null: false
    t.bigint "authable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authable_type", "authable_id"], name: "index_auths_on_authable_type_and_authable_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "author"
    t.text "content"
    t.string "isbn"
    t.string "publisher"
    t.string "title"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.string "title"
    t.bigint "book_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_chapters_on_book_id"
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "image"
    t.string "imageable_type", null: false
    t.bigint "imageable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likable_type", null: false
    t.bigint "likable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable_type_and_likable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "options", force: :cascade do |t|
    t.bigint "tutor_id"
    t.bigint "chapter_id"
    t.integer "weight"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chapter_id"], name: "index_options_on_chapter_id"
    t.index ["tutor_id"], name: "index_options_on_tutor_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "tutor_id", null: false
    t.string "description"
    t.integer "deposit"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", null: false
    t.datetime "started_at"
    t.integer "duration", default: 0
    t.integer "experience_period", default: 0
    t.bigint "category_id"
    t.integer "required_time", default: 0
    t.integer "review_weight", default: 0
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_projects_on_category_id"
    t.index ["deleted_at"], name: "index_projects_on_deleted_at"
    t.index ["tutor_id"], name: "index_projects_on_tutor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "phone"
    t.string "name", null: false
    t.text "info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", limit: 2, default: 0
    t.string "image"
    t.string "type"
    t.integer "likes_count", default: 0
    t.string "account_type"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attendances", "users", column: "tutee_id"
  add_foreign_key "chapters", "books"
  add_foreign_key "identities", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "options", "chapters"
  add_foreign_key "options", "users", column: "tutor_id"
  add_foreign_key "projects", "categories"
  add_foreign_key "projects", "users", column: "tutor_id"
end
