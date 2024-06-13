class AddUniqueIndexToUsersUsername < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :username, unique: true, length: 20
  end
end
