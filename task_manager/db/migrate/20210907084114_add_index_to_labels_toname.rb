class AddIndexToLabelsToname < ActiveRecord::Migration[6.1]
  def change
    add_index :labels, :name, unique: true
  end
end
