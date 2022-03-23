class AddReferencesToTasks < ActiveRecord::Migration[5.0]
  def change
    add_reference :tasks, :user, foreign_key: true
  end
end
