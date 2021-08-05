class AddTitleIndexToTask < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :name, type: :fulltext
  end
end
