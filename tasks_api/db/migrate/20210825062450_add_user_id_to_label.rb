class AddUserIdToLabel < ActiveRecord::Migration[6.1]
  def change
    add_column :labels, :user_id, :integer
  end
end
