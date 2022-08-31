class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name, limit: 64, null: false, default: 'not setting'
      t.integer :task_id, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
