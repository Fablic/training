class ChangeColumnsInTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :name, :string, limit: 30
    change_column :tasks, :description, :text, limit: 255
  end
end
