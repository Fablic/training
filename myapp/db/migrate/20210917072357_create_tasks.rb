class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :user,foreign_key:true
      t.integer :status,limit:1
      t.datetime :period_date
      t.integer :priority
      t.integer :label_id_1
      t.integer :label_id_2
      t.integer :label_id_3
      t.integer :label_id_4
      t.integer :label_id_5
      t.integer :regist_user
      t.integer :update_user
      t.boolean :del_flag, null:false, default:false
      t.timestamps
    end
  end
end
