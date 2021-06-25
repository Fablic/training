class AddIndexCreatedAtToTasks < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :created_at
  end
end
