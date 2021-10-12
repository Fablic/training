class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login_id, limit:10
      t.string :password, limit:12
      t.string :name, limit:20
      t.timestamp :create_dt, default: -> {'NOW()'}
      t.timestamp :update_dt
    end
  end
end
