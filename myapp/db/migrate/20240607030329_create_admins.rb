class CreateAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :admins do |t|
      t.references :user, null: false, foreign_key: true
    end
  end
end
