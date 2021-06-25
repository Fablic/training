class AddDueDateToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :due_date, :datetime, after: :description
  end
end
