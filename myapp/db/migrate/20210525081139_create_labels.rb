class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.string :color, null: false
      t.timestamps
      t.index [:user_id, :name], unique: true
    end
  end
end
