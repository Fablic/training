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

ActiveRecord::Schema[7.1].define(version: 2025_03_27_064209) do
  create_table "tasks", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.integer "priority", limit: 1, null: false
    t.integer "status", limit: 1, null: false
    t.timestamp "deadline", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["name"], name: "index_tasks_on_name"
    t.index ["status"], name: "index_tasks_on_status"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tasks_count", default: 0, null: false
    t.datetime "deleted_at"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "tasks", "users"
end
