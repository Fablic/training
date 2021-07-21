class AddIndexTaskLinksUserId < ActiveRecord::Migration[6.1]
  def change
    add_index :task_links, %i[user_id task_id]
  end
end
