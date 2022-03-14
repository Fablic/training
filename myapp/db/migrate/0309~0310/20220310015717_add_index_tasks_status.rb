class AddIndexTasksStatus < ActiveRecord::Migration[5.0]
  def change
    add_index :tasks, :status
  end
end
