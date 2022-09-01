class ChangeColumnsToTasks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :name, false
    change_column_null :tasks, :description, false
    change_column :tasks, :name, :string, limit: 10
    change_column :tasks, :description, :string, limit: 50
  end
end
