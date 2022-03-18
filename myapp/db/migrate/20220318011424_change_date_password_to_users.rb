class ChangeDatePasswordToUsers < ActiveRecord::Migration[5.0]
  def up
    rename_column :users, :password_digest, :password
    change_column :users, :password, :string
  end

  def down
    rename_column :users, :password, :password_digest
    change_column :users, :password_digest, :integer
  end
end
