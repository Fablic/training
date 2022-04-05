class ChangeTasksNameLimit50 < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :name, :string, limit: 50
  end

  def down
    change_column :tasks, :name, :string
  end
end
