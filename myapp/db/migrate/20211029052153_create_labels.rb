class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :label, null: false

      t.timestamps
    end
    add_index :labels, :label, unique: true
  end
end
