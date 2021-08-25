class AddTitleIndexToTask < ActiveRecord::Migration[6.1]
  def up
    execute 'create fulltext index index_tasks_on_name on tasks(name) with parser ngram'
  end

  def down
    remove_index :tasks, :name
  end
end
