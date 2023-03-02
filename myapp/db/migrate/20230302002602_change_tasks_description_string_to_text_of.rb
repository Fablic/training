class ChangeTasksDescriptionStringToTextOf < ActiveRecord::Migration[7.0]
  def up
    change_table :tasks do |t|
      t.change :description, :text
    end
  end

  def down
    change_table :tasks do |t|
      t.change :description, :string
    end
  end
end
