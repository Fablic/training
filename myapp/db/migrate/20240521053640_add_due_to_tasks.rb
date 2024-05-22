class AddDueToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :due, :timestamp, null: false
  end
end
