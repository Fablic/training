class ChangeDataDescriptionToTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :description, :text, null: false
  end
end
