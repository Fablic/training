class CreateTaskLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :task_links, id: :integer do |t|
      t.integer :task_id, null:false
      t.integer :user_id, null:false

      t.timestamps
    end
  end
end
