class CreateModes < ActiveRecord::Migration[6.1]
  def change
    create_table :modes, id: :integer do |t|
      t.string :mode_name, null: false
      t.boolean :value, null: false

      t.timestamps
    end
  end
end
