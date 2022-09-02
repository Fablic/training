class ChangeCloumnsNotnullAddTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :finish_at, :date, null: false
  end
end
