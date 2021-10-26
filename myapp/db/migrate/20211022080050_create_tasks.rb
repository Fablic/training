class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.bigint :user_id, null: false, comment: 'ユーザーID'
      t.string :title, limit: 255, null: false, comment: 'タイトル'
      t.string :description, limit: 768, comment: '内容'
      t.integer :status, limit: 1, comment: 'ステータス'
      t.integer :priority, limit: 3, comment: '優先度'
      t.datetime :expires_at, comment: '期限日時'

      t.timestamps
    end
  end
end
