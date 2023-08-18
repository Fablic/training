class RenamePasswordHashToPasswordDigest < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :password_hash, :password_digest
  end
end
