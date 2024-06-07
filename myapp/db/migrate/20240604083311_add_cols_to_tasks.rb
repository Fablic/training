class AddColsToTasks < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    change_column :tasks, :title, :string, limit: 255
    change_column :tasks, :details, :text, limit: 30_000
    add_column :tasks, :user_id, :integer, after: :title
    add_column :tasks, :start_date, :date, after: :user_id
    add_column :tasks, :due_date, :date, after: :start_date
    add_column :tasks, :status, :integer, default: 0, null: false, after: :due_date
    add_column :tasks, :priority, :integer, default: 1, null: false, after: :status
  end
end
