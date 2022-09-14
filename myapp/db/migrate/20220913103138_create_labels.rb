class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name, limit: 64

      t.timestamps
    end
  end
end
