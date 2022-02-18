class CreatePriorities < ActiveRecord::Migration[6.0]
  def change
    create_table :priorities do |t|
      t.string :title
      t.integer :sort
      t.string :color
      t.integer :board_id

      t.timestamps
    end
  end
end
