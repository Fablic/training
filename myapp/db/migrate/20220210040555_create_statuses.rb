class CreateStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :statuses do |t|
      t.string :title
      t.integer :sort

      t.timestamps
    end
  end
end
