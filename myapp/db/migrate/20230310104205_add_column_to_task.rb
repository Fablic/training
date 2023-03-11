class AddColumnToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :title, :string, limit: 100, null: false
    add_column :tasks, :description, :string, limit: 2000
    add_column :tasks, :status, :integer, null: false
    add_column :tasks, :delete_flag, :integer, null: false, default: 0
    add_column :tasks, :due_date, :datetime
  end
end
