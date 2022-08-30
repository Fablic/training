class ChangeTasksNameLimit30 < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :name, :string, limit: 30
  end
end
