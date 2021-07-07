class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.string :name, null: false, limit: 50, index: { unique: true }
      t.integer :color, default: 0

      t.timestamps
    end
  end
end
