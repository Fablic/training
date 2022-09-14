class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, limit: 128, null: false, default: ''
      t.text :description
      t.references :user
      t.string :status, limit: 1, null: false, default: '0'
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
