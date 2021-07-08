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

ActiveRecord::Schema.define(version: 2021_07_08_043127) do

  create_table "labels", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.integer "color", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_labels_on_name", unique: true
  end

  create_table "task_labels", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "label_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["label_id"], name: "index_task_labels_on_label_id"
    t.index ["task_id"], name: "index_task_labels_on_task_id"
  end

  create_table "tasks", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "end_at"
    t.integer "task_status", default: 0
    t.string "user_id"
    t.index ["created_at"], name: "index_tasks_on_created_at"
    t.index ["end_at"], name: "index_tasks_on_end_at"
    t.index ["task_status"], name: "index_tasks_on_task_status"
    t.index ["title"], name: "index_tasks_on_title"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", id: { type: :string, limit: 36, comment: "プライマリキー" }, charset: "utf8mb4", force: :cascade do |t|
    t.string "username", limit: 20, null: false
    t.string "icon"
    t.integer "role", default: 0, null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "task_labels", "labels"
  add_foreign_key "task_labels", "tasks"
  add_foreign_key "tasks", "users"
end
