class AddIndexToTasksTitleAndStatus < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, [:title,:status]
    add_index :tasks, :status
  end
end
