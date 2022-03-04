class ChangeCloumnsNotnullAddTasks < ActiveRecord::Migration[5.0]
  def change
    change_column :tasks, :task_name, :string, null: false
    change_column :tasks, :description, :string, null: false
  end
end
