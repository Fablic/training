class ChangeTaskStatusToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :status, :integer
  end
end
