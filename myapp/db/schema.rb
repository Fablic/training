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

ActiveRecord::Schema.define(version: 2022_03_15_014226) do

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "ユーザーID"
    t.string "title", limit: 45, null: false, comment: "タイトル"
    t.string "body", comment: "内容"
    t.integer "status", null: false, comment: "ステータス"
    t.integer "urgency", null: false, comment: "緊急度"
    t.integer "importance", null: false, comment: "重要度"
    t.integer "priority_point", null: false, comment: "優先順位ポイント"
    t.datetime "deadline", null: false, comment: "期限"
    t.integer "deleted", default: 0, null: false, comment: "削除フラグ"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 45, null: false, comment: "名前"
    t.string "email", null: false, comment: "メールアドレス"
    t.string "password_digest", null: false
    t.integer "deleted", default: 0, null: false, comment: "削除フラグ"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_token"
  end

end
