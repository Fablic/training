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

ActiveRecord::Schema.define(version: 2021_11_12_000001) do

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "task_name", limit: 20
    t.string "description", limit: 100
    t.string "status", limit: 10
    t.integer "priority"
    t.string "label", limit: 20
    t.timestamp "start_date"
    t.timestamp "end_date"
    t.boolean "deleted", default: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at"
    t.bigint "user_id", null: false
    t.index ["status"], name: "index_tasks_on_status"
    t.index ["task_name"], name: "index_tasks_on_task_name"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "login_id", limit: 10
    t.string "password", limit: 12
    t.string "name", limit: 20
    t.boolean "is_admin", default: true, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at"
  end

  add_foreign_key "tasks", "users"
end
