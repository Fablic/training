class CreateTaskLabels < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    create_table :task_labels do |t|
      t.references :task, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
    add_index :task_labels, %i[task_id label_id], unique: true
  end
end
