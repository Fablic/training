class Mode < ApplicationRecord
  def self.maintenance_start
    maintenance = find_by(mode_name: 'maintenance')
    maintenance.present? && maintenance.update(value: true)
  end

  def self.maintenance_end
    maintenance = find_by(mode_name: 'maintenance')
    maintenance.present? && maintenance.update(value: false)
  end
end
