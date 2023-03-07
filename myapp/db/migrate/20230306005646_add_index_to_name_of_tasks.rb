class AddIndexToNameOfTasks < ActiveRecord::Migration[7.0]
  def change
    add_index :tasks, :name
  end
end
