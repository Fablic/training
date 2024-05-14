class UpdateUsersLabelsType < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :username, false
    change_column_null :users, :password, false
    change_column_null :labels, :label_name, false
  end
end
