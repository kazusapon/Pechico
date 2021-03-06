# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_28_201501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "common_inquiries", force: :cascade do |t|
    t.integer "system_id"
    t.text "question"
    t.text "answer"
    t.integer "sort_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inquirier_kinds", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inquiries", force: :cascade do |t|
    t.integer "user_id"
    t.integer "system_id"
    t.integer "inquirier_kind_id"
    t.integer "inquiry_method_id"
    t.integer "inquiry_classification_id"
    t.integer "approver_id"
    t.integer "parent_inquiry_id"
    t.string "company_name"
    t.string "inquirier_name"
    t.string "telephone_number"
    t.string "sub_telephone_number"
    t.text "question"
    t.text "answer"
    t.boolean "is_completed"
    t.date "inquiry_date"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.time "start_time"
    t.time "end_time"
    t.datetime "approve_at"
  end

  create_table "inquiry_classifications", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "inquiry_relations", force: :cascade do |t|
    t.integer "inquiry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "systems", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "unregister_inquiries", force: :cascade do |t|
    t.integer "user_id"
    t.string "company_name"
    t.string "telephone_number"
    t.date "inquiry_date"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "inquirier_name"
    t.integer "inquirier_kind_id"
    t.integer "unknown_number_status"
    t.boolean "is_completed", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "login_id"
    t.string "name"
    t.string "password_digest"
    t.string "host"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
  end

end
