# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_211_201_065_713) do
  create_table 'tasks', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.bigint 'user_id', comment: 'User ID'
    t.string 'title', null: false, comment: 'タイトル'
    t.string 'description', limit: 768, comment: '内容'
    t.integer 'status', limit: 1, comment: 'ステータス'
    t.integer 'priority', limit: 3, comment: '優先度'
    t.datetime 'expires_at', comment: '期限日時'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['status'], name: 'index_status'
    t.index %w[title status], name: 'index_title_status'
    t.index ['user_id'], name: 'index_user_id'
  end

  create_table 'users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
    t.string 'name', limit: 32, comment: '名前'
    t.string 'email', limit: 128, comment: 'Emailアドレス'
    t.string 'password_digest', comment: 'パスワード'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end
