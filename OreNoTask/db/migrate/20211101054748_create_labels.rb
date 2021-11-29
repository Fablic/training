class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.string :name, null: false, limit: 20

      t.timestamps
    end
  end
end
