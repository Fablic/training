class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :string
    add_column :users, :password, :string
    add_column :users, :salt, :string
  end
end
