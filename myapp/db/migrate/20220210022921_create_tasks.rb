class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.date :deadline, null: false
      t.integer :priority, null: false
      t.integer :label_id, null: true
      t.integer :status, null: false
      t.integer :deleted, null: false, default: 0

      t.timestamps
    end
  end
end
