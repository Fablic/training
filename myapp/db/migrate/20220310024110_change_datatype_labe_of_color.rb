class ChangeDatatypeLabeOfColor < ActiveRecord::Migration[6.0]
  def change
    change_column :labels, :color, :string, default: '#FFFFFF'
  end
end
