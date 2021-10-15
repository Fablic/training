class RemoveIndexTasks < ActiveRecord::Migration[6.1]
  def change
    remove_index :tasks, :deleted
    remove_index :tasks, [:created_at, :deleted]
    remove_index :tasks, [:due_date_at, :deleted]
    remove_index :tasks, [:status, :deleted]
  end
end
