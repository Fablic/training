class AddBgcolorToLabe < ActiveRecord::Migration[6.0]
  def change
    add_column :labels, :bgcolor, :string, default: '#009688'
  end
end
