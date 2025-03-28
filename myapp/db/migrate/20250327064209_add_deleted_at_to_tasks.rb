class AddDeletedAtToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :deleted_at, :datetime
  end
end
