# frozen_string_literal: true

class AddIndexToMaintenance < ActiveRecord::Migration[6.0]
  def change
    add_index :maintenances, %i[start_datetime end_datetime]
  end
end
