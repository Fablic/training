class RemoveStatusToTasks < ActiveRecord::Migration[5.0]
  def change
    remove_column :tasks, :status, :string
  end
end
