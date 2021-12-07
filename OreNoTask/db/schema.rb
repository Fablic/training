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

ActiveRecord::Schema.define(version: 2021_11_01_060229) do

  create_table "labels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.integer "deleted", limit: 1, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "deleted"], name: "index_labels_on_name_and_deleted"
  end

  create_table "task_labels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "task_id"
    t.bigint "label_id"
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description"
    t.integer "status", limit: 1, default: 0, null: false
    t.datetime "start_at", null: false
    t.datetime "due_date_at", null: false
    t.integer "deleted", limit: 1, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id", "created_at", "deleted"], name: "index_tasks_on_user_id_and_created_at_and_deleted"
    t.index ["user_id", "deleted"], name: "index_tasks_on_user_id_and_deleted"
    t.index ["user_id", "due_date_at", "deleted"], name: "index_tasks_on_user_id_and_due_date_at_and_deleted"
    t.index ["user_id", "status", "deleted"], name: "index_tasks_on_user_id_and_status_and_deleted"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.integer "privilege", limit: 1, default: 0, null: false
    t.integer "deleted", limit: 1, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest", null: false
  end

  add_foreign_key "tasks", "users"
end
