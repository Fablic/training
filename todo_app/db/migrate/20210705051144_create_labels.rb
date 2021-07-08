class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.string :name, null: false, index: { unique: true }, limit: 191

      t.timestamps
    end
  end
end
