class AddColumnsToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :priority, :integer, null: true, limit: 1
    add_column :tasks, :status, :integer, null: true, limit: 1
    add_column :tasks, :due_date, :datetime
  end
end
