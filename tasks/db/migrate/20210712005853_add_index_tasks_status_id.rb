class AddIndexTasksStatusId < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, %i[status_id limit_date created_at], name: 'index_tasks_on_status_id_and_limit_date_and_created_at'
  end
end
