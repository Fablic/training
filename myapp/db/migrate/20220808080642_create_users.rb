class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: '', limit: 128
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
