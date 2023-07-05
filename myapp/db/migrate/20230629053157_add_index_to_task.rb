class AddIndexToTask < ActiveRecord::Migration[7.0]
  def change
    add_index :tasks, :status
  end
end
