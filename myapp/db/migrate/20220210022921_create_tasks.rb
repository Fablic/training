class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.text :body
      t.date :deadline
      t.integer :priority
      t.integer :label_id, null: false
      t.integer :status
      t.integer :deleted, default: 0

      t.timestamps
    end
  end
end
