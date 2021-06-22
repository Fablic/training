class CreateMasterTaskPriorities < ActiveRecord::Migration[6.1]
  def change
    create_table :master_task_priorities, id: :integer, limit:1 do |t|
      t.string :priority, limit:64, null:false

      t.timestamps
    end
  end
end
