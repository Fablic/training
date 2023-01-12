class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings, id: :unsigned_integer do |t|
      t.integer :tag_id, null: false, foreign_key: true
      t.integer :task_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
