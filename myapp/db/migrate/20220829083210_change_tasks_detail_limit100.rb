class ChangeTasksDetailLimit100 < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :detail, :string, limit: 100
  end
end
