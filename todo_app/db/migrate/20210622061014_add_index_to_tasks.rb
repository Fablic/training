class AddIndexToTasks < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :title
    add_index :tasks, :task_status
    add_index :tasks, :end_at
    add_index :tasks, :created_at
  end
end
