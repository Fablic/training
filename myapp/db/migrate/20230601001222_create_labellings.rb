class CreateLabellings < ActiveRecord::Migration[6.0]
  def change
    create_table :labellings do |t|
      t.references :task, foreign_key: true
      t.references :label, foreign_key: true

      t.timestamps
    end
    add_index :labellings, [:task_id, :label_id], unique: true
  end
end
