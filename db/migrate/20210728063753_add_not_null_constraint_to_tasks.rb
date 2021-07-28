class AddNotNullConstraintToTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tasks, :name, false, "default name"
  end
end
