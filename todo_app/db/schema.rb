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

ActiveRecord::Schema.define(version: 2021_06_28_050541) do

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
    t.integer "role", default: 0
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "tasks", "users"
end
