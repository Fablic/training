class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :label
      t.integer :color
      t.integer :deleted, default: 0

      t.timestamps
    end
  end
end
