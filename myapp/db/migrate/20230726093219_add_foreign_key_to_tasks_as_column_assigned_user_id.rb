class AddForeignKeyToTasksAsColumnAssignedUserId < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :tasks, :users, column: :assigned_user_id, primary_key: "id"
  end
end
