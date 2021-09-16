class AddUserIdToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :user_id, :string, after: :id
  end
end
