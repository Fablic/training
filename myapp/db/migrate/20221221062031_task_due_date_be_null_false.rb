class TaskDueDateBeNullFalse < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :due_date, :datetime, null: false
  end

  def down
    change_column :tasks, :due_date, :datetime
  end
end
