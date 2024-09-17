class Maintenance < ApplicationRecord
  enum :is_maintenance, { off: 0, on: 1 }, validate: true

  validates :ended_at, comparison: { greater_than: :started_at }
end
