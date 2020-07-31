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

ActiveRecord::Schema.define(version: 2020_07_30_063549) do
  create_table 'app_users', force: :cascade do |t|
    t.string 'name', limit: 100, null: false
    t.string 'hashed_password', null: false
    t.date 'start_date', null: false
    t.date 'end_date'
    t.boolean 'suspended', default: false, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'admin', default: false
    t.index ['name'], name: 'idx_app_user_unique_name', unique: true
  end

  create_table 'maintenances', force: :cascade do |t|
    t.string 'reason'
    t.datetime 'start_datetime'
    t.datetime 'end_datetime'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[start_datetime end_datetime], name: 'index_maintenances_on_start_datetime_and_end_datetime'
  end

  create_table 'task_labels', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'task_id'
    t.index ['task_id'], name: 'index_task_labels_on_task_id'
  end

  create_table 'tasks', force: :cascade do |t|
    t.string 'name'
    t.integer 'status', default: 0
    t.date 'due_date'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'app_user_id'
    t.index ['app_user_id'], name: 'index_tasks_on_app_user_id'
    t.index ['status'], name: 'index_tasks_on_status'
  end

  add_foreign_key 'task_labels', 'tasks'
  add_foreign_key 'tasks', 'app_users'
end
