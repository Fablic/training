class AddDueDateToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :due_date, :datetime, null: false
  end
end
