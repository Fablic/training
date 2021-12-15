class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels do |t|
      t.references :task, index: true, null: false, foreign_key: true
      t.references :label, index: true, null: false, foreign_key: true

      t.timestamps
    end
  end
end
