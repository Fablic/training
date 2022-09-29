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

ActiveRecord::Schema[7.0].define(version: 2022_09_29_003326) do
  create_table "tasks", charset: "utf8mb4", comment: "タスク", force: :cascade do |t|
    t.string "name", null: false, comment: "タスク名"
    t.datetime "end_date", comment: "終了期限"
    t.integer "priority", null: false, comment: "優先順位: 0:低(low), 1:普通(normal), 2:高(high)"
    t.integer "status", null: false, comment: "ステータス: 0:未着手(untouched), 1:着手中(touched), 2:完了(completed)"
    t.text "explanation", comment: "説明文"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "status"], name: "index_tasks_on_name_and_status"
  end

end
