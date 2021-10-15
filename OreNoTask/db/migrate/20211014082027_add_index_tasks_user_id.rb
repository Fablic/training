class AddIndexTasksUserId < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, [:user_id, :deleted]
    add_index :tasks, [:user_id, :created_at, :deleted]
    add_index :tasks, [:user_id, :due_date_at, :deleted]
    add_index :tasks, [:user_id, :status, :deleted]
  end
end
