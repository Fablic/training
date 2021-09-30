class AddUserIdToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :user_id, :bigint, after: :id, null: false
  end
end
