class AddUserIdToTasks < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :user, foreign_key: true
    change_column :tasks, :user_id, :bigint, null: false
  end
end
