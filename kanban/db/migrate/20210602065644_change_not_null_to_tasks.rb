class ChangeNotNullToTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tasks, :name, false
  end
end
