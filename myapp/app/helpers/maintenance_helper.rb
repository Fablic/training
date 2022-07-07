module MaintenanceHelper
  def maintenance?
    File.exist? Constants::MAINTENANCE_FILE_PATH
  end
end
