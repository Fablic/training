class AddIndexTasksBoardId < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, [:board_id, :status_id]
    add_index :tasks, [:board_id, :priority_id]
    add_index :tasks, [:board_id, :due_date]
    add_index :priorities, [:board_id]
    add_index :statuses, [:board_id]
    add_index :status_steps, [:from_status_id]
    add_index :tags, [:board_id]
    add_index :tags_tasks, [:tag_id]
    add_index :tags_tasks, [:task_id]
    add_index :boards_users, [:board_id, :user_id]
  end
end
