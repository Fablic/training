class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels do |t|
      t.references :task, foreign_key: true, null: false
      t.references :label, foreign_key: true, null: false
    end
  end
end
