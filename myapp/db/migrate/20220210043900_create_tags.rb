class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :tag
      t.integer :board_id

      t.timestamps
    end
  end
end
