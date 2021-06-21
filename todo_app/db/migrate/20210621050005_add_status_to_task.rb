class AddStatusToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :task_status, :integer, default: 0
  end
end
