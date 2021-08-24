class CreateTaskLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :task_labels do |t|
      t.integer :task_id
      t.integer :label_id

      t.timestamps
    end
  end
end
