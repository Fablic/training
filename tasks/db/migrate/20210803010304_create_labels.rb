class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels, id: :integer do |t|
      t.string :label_name

      t.timestamps
    end
  end
end
