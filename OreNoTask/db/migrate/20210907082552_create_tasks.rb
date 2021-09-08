class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :task_name
      t.text :task_description
      t.integer :status
      t.datetime :start_date
      t.datetime :due_date
      t.integer :deleted

      t.timestamps
    end
  end
end
