class CreateTaskToLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_to_labels do |t|
      t.references :task, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true
      t.datetime :discarded_at

      t.timestamps
    end
  end
end
