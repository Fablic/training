class AddStatusColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :status, :integer, after: :name

  end
end
