class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.text :name
      t.references :user,foreign_key:true
      t.integer :regist_user
      t.integer :update_user
      t.boolean :del_flag, null:false, default:false
      t.timestamps
    end
  end
end
