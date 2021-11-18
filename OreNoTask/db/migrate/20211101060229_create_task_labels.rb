class CreateTaskLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :task_labels do |t|
      t.references :task, foreign_key: true
      t.references :label, foreign_key: true
      t.index %i[task_id label_id]
    end
  end
end
