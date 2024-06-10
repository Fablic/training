class AddIndexToTask < ActiveRecord::Migration[7.0] # rubocop:disable Style/Documentation
  def change
    add_index :tasks, :title
    add_index :tasks, :status
  end
end
