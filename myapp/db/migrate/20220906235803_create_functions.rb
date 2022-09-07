class CreateFunctions < ActiveRecord::Migration[6.0]
  def change
    create_table :functions do |t|
      t.string :name
      t.string :status, limit: 1, null: false, default: '1'
      t.timestamps
    end
  end
end
