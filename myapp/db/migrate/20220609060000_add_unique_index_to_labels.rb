class AddUniqueIndexToLabels < ActiveRecord::Migration[6.0]
  def change
    add_index :labels, [:name, :user_id], unique: true
  end
end
