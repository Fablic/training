class CreateConstants < ActiveRecord::Migration[6.0]
  def change
    create_table :constants do |t|
      t.string :key, null: false
      t.boolean :value, default: false, null: false

      t.timestamps
    end
  end
end
