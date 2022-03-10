class ChangeDatatypeTaskOfLabelId < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :label_id, :string, default: ''
  end
end
