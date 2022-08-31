class RemoveLabelFromTasks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tasks, :label, :string
  end
end
