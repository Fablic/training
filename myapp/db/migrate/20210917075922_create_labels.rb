class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.text :name
      t.references :user,foreign_key:true
      t.datetime : regist_date , default : ->{ 'NOW()'}
      t.integer :regist_user
      t.datetime :update_date ,
      t.integer :update_user
      t.boolean :del_flag, null:false, default:false
      t.timestamps
    end
  end
end
