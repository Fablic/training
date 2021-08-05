class AddStatusToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :status, :integer, default: 0, null: false
  end
end
