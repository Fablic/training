class CreateTaskLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :task_labels do |t|
      t.references :task, foreign_key: true
      t.references :label, foreign_key: true

      t.timestamps
    end
  end
end
