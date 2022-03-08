class ChangeCloumnsNotnullAddTasks < ActiveRecord::Migration[5.0]
  def up
    change_column :tasks, :task_name, :string, null: false, limit: 30
    change_column :tasks, :description, :string, null: false, limit: 100
  end

  def down
    change_column :tasks, :task_name, :string
    change_column :tasks, :description, :string
  end
end
