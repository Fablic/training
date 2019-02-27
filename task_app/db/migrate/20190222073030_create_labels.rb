class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :labels, [:user_id, :name], unique: true
  end
end
