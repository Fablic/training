class AddColumnToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :deleted, :integer, limit: 1, default: 0, null: false
  end
end
