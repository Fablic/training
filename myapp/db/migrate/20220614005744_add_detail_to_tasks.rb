class AddDetailToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :priority, :integer
    add_column :tasks, :status, :integer
    add_column :tasks, :limit, :date
    add_reference :tasks, :user, foreign_key: true
  end
end
