class AddIndexTasksTitle < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :title
  end
end
