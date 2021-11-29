# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, limit: 255, null: false, comment: 'タイトル'
      t.string :description, limit: 768, comment: '内容'
      t.integer :status, limit: 1, comment: 'ステータス'
      t.integer :priority, limit: 3, comment: '優先度'
      t.datetime :expires_at, comment: '期限日時'
      t.index ['status'], name: 'index_status'
      t.index %w[title status], name: 'index_title_status'
      t.timestamps
    end
  end
end
