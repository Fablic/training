class ModifyTaskDescription < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :description, :text
    change_column_null :tasks, :description, true
  end
end
