class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags, id: :unsigned_integer do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
