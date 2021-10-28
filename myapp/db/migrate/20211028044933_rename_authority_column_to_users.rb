class RenameAuthorityColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :authority, :role
  end
end
