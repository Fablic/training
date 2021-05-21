class AddIndexToNameAndStatusOnTasks < ActiveRecord::Migration[6.0]
  def change
    change_table :tasks, bulk: true do |t|
      t.index :name
      t.index :status
    end
  end
end
