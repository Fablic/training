class CreateLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :labels, id: false do |t|
      t.primary_key :id, :unsigned_integer, limit: 8, null: false, auto_increment: true
      t.string :name, limit: 20

      t.timestamps
    end
    add_index :labels, :name
  end
end
