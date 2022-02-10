class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :label
      t.integer :color
      t.integer :deleted

      t.timestamps
    end
  end
end
