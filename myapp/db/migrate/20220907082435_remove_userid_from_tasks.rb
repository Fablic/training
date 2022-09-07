class RemoveUseridFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :user_id
    add_reference :tasks, :user, null: false
  end
end
