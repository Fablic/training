class AddTaskStatusIdToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :task_status_id, :integer, :null => false
  end
end
