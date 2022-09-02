class ChangeDatatypeStatusOfTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :status, :integer, null: false
  end
end
