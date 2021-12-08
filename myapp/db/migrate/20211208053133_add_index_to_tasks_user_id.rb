class AddIndexToTasksUserId < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, %i[user_id created_at]
  end
end
