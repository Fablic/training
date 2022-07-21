class ChangeColumnNotNullToUser < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :admin, false
  end
end
