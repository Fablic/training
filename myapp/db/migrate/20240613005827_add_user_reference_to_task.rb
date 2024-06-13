class AddUserReferenceToTask < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    remove_column :tasks, :user_id, :integer
    add_reference :tasks, :user, foreign_key: true, null: true
  end
end
