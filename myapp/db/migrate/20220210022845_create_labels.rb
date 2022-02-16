class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :label, null: false
      t.integer :color, null: false
      t.integer :deleted, null: false, default: 0

      t.timestamps
    end
  end
end
