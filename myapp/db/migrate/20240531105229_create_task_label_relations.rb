class CreateTaskLabelRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :task_label_relations do |t|
      t.references :task, null: false, foreign_key: false
      t.references :label, null: false, foreign_key: false

      t.timestamps
    end
  end
end
