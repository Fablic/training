class AddColumnPasswordDigests < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_digest, :string, limit: 128, null: false
  end
end
