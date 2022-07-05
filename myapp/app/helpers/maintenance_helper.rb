module MaintenanceHelper
  MAINTENANCE_FILE_PATH = Rails.root.join('tmp', 'maintenance.txt')
  def maintenance?
    File.exist? MAINTENANCE_FILE_PATH
  end
end
