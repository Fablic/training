class Maintenance < ApplicationRecord
  enum :is_maintenance, { off: 0, on: 1 }, validate: true

  validates :ended_at, comparison: { greater_than: :started_at }, if: :maintenance_on?

  def maintenance_on?
    Maintenance.is_maintenances[is_maintenance] == Maintenance.is_maintenances[:on]
  end
end
