class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.integer :user_id, null: false, comment: 'ユーザーID'
      t.string :name, limit: 45, null: false, comment: '名前'
      t.integer :color, null: false, comment: 'カラー'
      t.integer :deleted, null: false, default: 0, comment: '削除フラグ'

      t.timestamps
    end
  end
end
