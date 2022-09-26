class ChangeColumnsAddUniqueOnUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :personal_id, unique: true
  end
end
