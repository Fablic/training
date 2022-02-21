class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :label, null: false
      t.integer :color, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
