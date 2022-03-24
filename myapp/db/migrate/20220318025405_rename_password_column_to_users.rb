class RenamePasswordColumnToUsers < ActiveRecord::Migration[5.0]
  def up
    rename_column :users, :password, :password_digest
  end

  def down
    rename_column :users, :password_digest, :password
  end
end
