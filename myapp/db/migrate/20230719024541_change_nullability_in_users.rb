class ChangeNullabilityInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :username, false
    change_column_null :users, :email, false
    change_column_null :users, :password_hash, false
  end
end
