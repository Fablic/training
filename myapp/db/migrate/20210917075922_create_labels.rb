class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.text :name
      t.integer :user_id

      t.timestamps
    end
  end
end
