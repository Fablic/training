class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.bigint :created_by, null:false
      t.string :name, limit: 256, null:false

      t.timestamps
    end
  end
end
