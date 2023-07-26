class ModifyAssignedUserIdType < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :assigned_user_id, :bigint
  end
end
