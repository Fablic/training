class AddUserIdToTasks < ActiveRecord::Migration[7.0]
  def up
    add_column :tasks, :user_id, :integer, limit: 8, unsigned: true, null: false, default: 0, if_not_exists: true
  end

  def down
    remove_column :tasks, :user_id, if_exists: true
  end
end
