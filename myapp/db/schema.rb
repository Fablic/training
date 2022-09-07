# frozen_string_literal: true

ActiveRecord::Schema[7.0].define(version: 20_220_907_012_956) do
  create_table 'tasks', charset: 'utf8mb4', force: :cascade do |t|
    t.string 'name', null: false, comment: 'タスク名'
    t.datetime 'end_date', comment: '終了期限'
    t.integer 'priority', default: 1, comment: '優先順位: 0:低(low), 1:普通(normal), 2:高(high)'
    t.integer 'status', default: 0, comment: 'ステータス: 0:未着手(untouched), 1:着手中(touched), 2:完了(completed)'
    t.text 'explanation', comment: '説明文'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
