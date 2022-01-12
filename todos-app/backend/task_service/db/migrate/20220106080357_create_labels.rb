class CreateLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :labels do |t|
      t.integer :user_id, null: false
      t.string :name, null: false, limit: 15
      t.index [:user_id, :name], unique: true

      t.timestamps
    end
  end
end
