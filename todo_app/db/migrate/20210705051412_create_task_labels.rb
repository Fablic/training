class CreateTaskLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :task_labels do |t|
      t.references :label, foreign_key: true
      t.references :task, foreign_key: true
    end
  end
end
