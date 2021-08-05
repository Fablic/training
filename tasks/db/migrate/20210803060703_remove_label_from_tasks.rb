class RemoveLabelFromTasks < ActiveRecord::Migration[6.1]
  def change
    remove_column :tasks, :label, :string, limit: 64, default: nil
  end
end
