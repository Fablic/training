# frozen_string_literal: true

class Maintenance < ApplicationRecord
  validates :reason, presence: true, length: { maximum: 255 }
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true

  def self.find_maintenance
    now = Time.zone.now
    Maintenance.where('start_datetime <= ? and end_datetime >= ?', now, now)
        .order(:start_datetime).order(:end_datetime).first
  end
end
