class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels do |t|
      t.belongs_to :task
      t.belongs_to :label

      t.timestamps
    end
  end
end
