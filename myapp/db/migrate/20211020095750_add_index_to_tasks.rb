class AddIndexToTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :name, :string, limit: 191
    change_column :users, :mail_address, :string, limit: 191
    add_index :tasks, :name
    add_index :users, :mail_address, unique: true
  end
end
