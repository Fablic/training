class DropTags < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :tasks, :tags
    drop_table :tags do |t|
      t.string "name"
    end
  end
end
