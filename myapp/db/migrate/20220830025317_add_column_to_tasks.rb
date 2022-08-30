class AddColumnToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :finish_at, :timestamp
  end
end
