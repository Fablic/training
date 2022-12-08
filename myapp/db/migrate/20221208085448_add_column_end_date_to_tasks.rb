# frozen_string_literal: true

class AddColumnEndDateToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :end_date, :datetime
  end
end
