class RemoveForeignKeyFromAssignedUserId < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :tasks, name: :fk_rails_190ed5bb66
  end
end
