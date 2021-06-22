class CreateMasterTaskStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :master_task_statuses, id: :integer, limit:1 do |t|
      t.string :status, limit:64, null:false

      t.timestamps
    end
  end
end
