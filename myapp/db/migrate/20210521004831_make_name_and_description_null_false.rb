class MakeNameAndDescriptionNullFalse < ActiveRecord::Migration[6.0]
  def change
    change_table :tasks, bulk: true do |t|
      t.change_default :name, ''
      t.change_default :description, ''

      # #change_null is introduced in Rails 6.1.0
      # t.change_null :name, false
      # t.change_null :description, false
    end
    change_column_null :tasks, :name, false
    change_column_null :tasks, :description, false
  end
end
