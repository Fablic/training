class ChangeDataValueToConstant < ActiveRecord::Migration[6.0]
  def change
    change_column :constants, :value, :string
  end
end
