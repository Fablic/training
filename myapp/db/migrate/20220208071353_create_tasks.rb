class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :board_id
      t.integer :user_id
      t.string :title
      t.text :contents
      t.integer :status_id
      t.integer :priority_id
      t.datetime :due_date
      t.datetime :modified_at

      t.timestamps
    end
  end
end
