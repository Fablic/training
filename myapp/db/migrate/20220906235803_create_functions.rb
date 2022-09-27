class CreateFunctions < ActiveRecord::Migration[6.0]
  def change
    create_table :functions do |t|
      t.string :name
      t.boolean :status, default: true
      t.timestamps
    end
  end
end
