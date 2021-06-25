class AddColumnStatusToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :status, :integer, default: 1, null: false, after: :due_date
  end
end
