class AddTaskStatusToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :status, :string, :null => false
  end
end
