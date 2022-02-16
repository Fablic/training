class CreateBoardsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :boards_users do |t|
      t.integer :permissions
      t.integer :board_id
      t.integer :user_id

      t.timestamps
    end
  end
end
