class CreateTagsTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tags_tasks do |t|
      t.integer :board_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
