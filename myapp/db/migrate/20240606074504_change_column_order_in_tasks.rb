# カラムの位置調整のALTER
class ChangeColumnOrderInTasks < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE tasks
      MODIFY COLUMN created_at datetime(6) NOT NULL AFTER due_date,
      MODIFY COLUMN updated_at datetime(6) NOT NULL AFTER created_at;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE tasks
      MODIFY COLUMN created_at datetime(6) NOT NULL AFTER details,
      MODIFY COLUMN updated_at datetime(6) NOT NULL AFTER created_at;
    SQL
  end
end
