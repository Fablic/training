class ChangeDatatypeDescriptionAndTitleOfTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, limit: 50
      t.text :description, null: true, limit: 255
  end
end
