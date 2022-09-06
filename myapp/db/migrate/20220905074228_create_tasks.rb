# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string     :name, null: false, limit: 255, comment: 'タスク名'
      t.datetime   :end_date,                             comment: '終了期限'
      t.integer    :priority,                 default: 1, comment: '優先順位: 0:低(low), 1:普通(normal), 2:高(high)'
      t.integer    :status,                   default: 0,
                                              comment: 'ステータス: 0:未着手(untouched), 1:着手中(touched), 2:完了(completed)'
      t.text       :explanation, comment: '説明文'

      t.timestamps
    end
  end
end
