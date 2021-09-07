class AddIndexToTasksTitle < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :title
    add_index :tasks, :status
  end
end
