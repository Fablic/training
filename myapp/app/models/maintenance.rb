# frozen_string_literal: true

class Maintenance
  MAINTENANCE_FILE_PATH = './config/maintanance.txt'

  def self.start
    file = File.open(MAINTENANCE_FILE_PATH, 'w')
    file.puts()
    file.close
  end

  def self.stop
    File.delete(MAINTENANCE_FILE_PATH) if File.exist? MAINTENANCE_FILE_PATH
  end

  def self.status?
    File.exist?(MAINTENANCE_FILE_PATH)
  end
end
