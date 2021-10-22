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

ActiveRecord::Schema.define(version: 2021_10_21_001832) do

  create_table "labels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "name"
    t.bigint "user_id"
    t.boolean "del_flag", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_labels_on_user_id"
  end

  create_table "labels_tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "label_id", null: false
    t.index ["label_id"], name: "index_labels_tasks_on_label_id"
    t.index ["task_id"], name: "index_labels_tasks_on_task_id"
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 191, comment: "タスク名"
    t.string "description", limit: 1024, comment: "コメント"
    t.bigint "user_id"
    t.integer "status", default: 0, comment: "状態"
    t.datetime "due_date", comment: "終了期限"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tasks_on_name"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "mail_address", limit: 191
    t.integer "role_id", limit: 1
    t.datetime "last_login_date"
    t.string "password_digest", comment: "暗号化パスワード"
    t.boolean "del_flag", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_digest"
    t.index ["mail_address"], name: "index_users_on_mail_address", unique: true
  end

  add_foreign_key "labels", "users"
  add_foreign_key "labels_tasks", "labels"
  add_foreign_key "labels_tasks", "tasks"
  add_foreign_key "tasks", "users"
end
