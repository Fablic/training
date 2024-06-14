class CreateUserTaskRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :user_task_relations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
