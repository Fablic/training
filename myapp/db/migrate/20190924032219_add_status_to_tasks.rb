class AddStatusToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :status, :integer, unsigned: true, default: 0, null: false, limit: 1, :after => :description
    add_index :tasks, :status
  end
end
