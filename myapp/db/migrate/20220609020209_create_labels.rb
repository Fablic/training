class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name, limit: 25, null: false
      t.references :user, foreign_key: true, null: false
    end
  end
end
