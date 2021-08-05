class CreateLabelLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :label_links, id: :integer do |t|
      t.references :label, null: false, foreign_key: true, type: :integer
      t.references :task, null: false, foreign_key: true, type: :integer

      t.timestamps
    end
  end
end
