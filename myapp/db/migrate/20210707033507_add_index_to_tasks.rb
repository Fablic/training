class AddIndexToTasks < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :user_id
  end
end
