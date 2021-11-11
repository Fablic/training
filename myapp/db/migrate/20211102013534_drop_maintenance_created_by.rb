# frozen_string_literal: true

class DropMaintenanceCreatedBy < ActiveRecord::Migration[6.0]
  def change
    remove_column :maintenances, :created_by
  end
end
