class CreateStatusSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :status_steps do |t|
      t.integer :from_status_id
      t.integer :to_status_id

      t.timestamps
    end
  end
end
