class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels do |t|
      t.bigint :task_id, null:false
      t.bigint :label_id, null:false

      t.timestamps
    end
  end
end
