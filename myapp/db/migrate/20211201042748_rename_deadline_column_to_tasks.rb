class RenameDeadlineColumnToTasks < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :deadline, :deadline_at
  end
end
