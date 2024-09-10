class AddFkToTasksForUsers < ActiveRecord::Migration[7.0]
  def up
    add_foreign_key :tasks, :users
  end
  def down
    remove_foreign_key :tasks, :users, if_exists: true
  end
end
