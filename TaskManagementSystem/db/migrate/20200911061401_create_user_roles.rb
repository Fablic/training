class CreateUserRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_roles do |t|
      t.bigint :user_id, null: false
      t.bigint :role_id, null: false

      t.timestamps
    end
  end
end
