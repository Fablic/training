class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id, null: false, comment: 'ユーザーID'
      t.string :title, limit: 45, null: false, comment: 'タイトル'
      t.string :body, limit: 255, comment: '内容'
      t.integer :status, null: false, comment: 'ステータス'
      t.integer :urgency, null: false, comment: '緊急度'
      t.integer :importance, null: false, comment: '重要度'
      t.integer :priority_point, null: false, comment: '優先順位ポイント'
      t.datetime :deadline, null: false, comment: '期限'
      t.integer :deleted, null: false, default: 0, comment: '削除フラグ'

      t.timestamps
    end
  end
end
