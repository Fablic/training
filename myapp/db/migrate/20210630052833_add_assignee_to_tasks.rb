class AddAssigneeToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :assignee, :integer
  end
end
