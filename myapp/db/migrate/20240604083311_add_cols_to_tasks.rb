class AddColsToTasks < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    change_column :tasks, :title, :string, limit: 255
    change_column :tasks, :details, :text, limit: 30_000
    add_column :tasks, :priority, :integer, default: 1, null: false
    add_column :tasks, :status, :integer, default: 0, null: false
    add_column :tasks, :user_id, :integer
    add_column :tasks, :start_date, :date
    add_column :tasks, :due_date, :date
  end
end
