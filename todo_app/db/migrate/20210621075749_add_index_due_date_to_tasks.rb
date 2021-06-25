class AddIndexDueDateToTasks < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :due_date
  end
end
