class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :description
      t.integer :priority, null: false, default: 0  # 0: High, 1: Medium, 2: Low
      t.integer :status, null: false, default: 0  # 0: Not started, 1: In progress, 2: Done
      t.datetime :due_datetime  # In UTC

      t.timestamps  # In UTC
    end
  end
end
