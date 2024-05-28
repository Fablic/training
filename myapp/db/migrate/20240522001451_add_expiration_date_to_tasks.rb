# frozen_string_literal: true

class AddExpirationDateToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :expiration_date, :datetime
  end
end
