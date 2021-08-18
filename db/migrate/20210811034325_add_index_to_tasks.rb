class AddIndexToTasks < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :status
  end
end
