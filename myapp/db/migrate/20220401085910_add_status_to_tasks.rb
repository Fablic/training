class AddStatusToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :status, :integer, null: false, default: 0
  end
end
