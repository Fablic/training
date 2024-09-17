class AddDeletedAtToUsersAndTasks < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :deleted_at, :datetime, default: nil, if_not_exists: true
    add_index :users, :deleted_at

    add_column :tasks, :deleted_at, :datetime, default: nil, if_not_exists: true
    add_index :tasks, :deleted_at
  end

  def down
    remove_index :users, :deleted_at, if_exists: true
    remove_column :users, :deleted_at, if_exists: true

    remove_index :tasks, :deleted_at, if_exists: true
    remove_column :tasks, :deleted_at, if_exists: true
  end
end
