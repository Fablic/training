class AddIndexToTasksUserId < ActiveRecord::Migration[7.1]
  def change
    add_index :tasks, :user_id
    add_foreign_key :tasks, :users
  end
end
