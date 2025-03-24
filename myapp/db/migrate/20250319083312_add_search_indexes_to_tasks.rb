class AddSearchIndexesToTasks < ActiveRecord::Migration[7.1]
  def change
    add_index :tasks, :status
  end
end
