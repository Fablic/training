class CreateConstants < ActiveRecord::Migration[6.0]
  def change
    create_table :constants do |t|
      t.boolean :maintenance_mode, default: false, null: false

      t.timestamps
    end
  end
end
