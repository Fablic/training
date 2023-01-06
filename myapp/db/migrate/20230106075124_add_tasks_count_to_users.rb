class AddTasksCountToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :tasks_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE users
           SET tasks_count = (SELECT count(1)
                              FROM tasks
                              WHERE tasks.user_id = users.id)
    SQL
  end
end
