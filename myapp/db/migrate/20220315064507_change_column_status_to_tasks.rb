class ChangeColumnStatusToTasks < ActiveRecord::Migration[5.0]
  def change
    remove_column :tasks, :status, :string
    add_column :tasks, :status, :integer, null: false, default: 0
    add_index :tasks, :status
  end
end
