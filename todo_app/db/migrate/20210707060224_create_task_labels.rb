class CreateTaskLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :task_labels do |t|
      t.references :task, null: false, index: true, foreign_key: true
      t.references :label, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
