class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.text :name
      t.references :user, foreign_key: true
      t.integer :regist_user_id, foreign_key: { to_table: :users }
      t.integer :update_user_id, foreign_key: { to_table: :users }
      t.boolean :del_flag, null: false, default: false
      t.timestamps
    end
  end
end
