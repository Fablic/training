class AddLabelIdsToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :label_id_1, :integer
    add_column :tasks, :label_id_2, :integer
    add_column :tasks, :label_id_3, :integer
    add_column :tasks, :label_id_4, :integer
    add_column :tasks, :label_id_5, :integer
  end
end
