class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.string :name, null: false, limit: 20
      t.integer :deleted, null: false, default: 0, limit: 1

      t.timestamps

      t.index %i[name deleted]
    end
  end
end
