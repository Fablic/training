class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name, null: false, default: 'New Label'
      t.timestamps
    end
  end
end
