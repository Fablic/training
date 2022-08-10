class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, limit: 128, null: false, default: ''
      t.text :description, null: false
      t.integer :user_id, limit: 8, null: false
      t.string :status, limit: 1, null: false, default: '0'
      t.string :label, limit: 64
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
