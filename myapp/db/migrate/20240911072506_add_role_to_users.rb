class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :role, :integer, limit: 1, null: false, default: 0, unsigned: true, if_not_exists: true
  end

  def down
    remove_column :users, :role, if_exists: true
  end
end
