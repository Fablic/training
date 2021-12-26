# frozen_string_literal: true

require 'tmpdir'

class Maintenance
  MAINTENANCE_FILE_PATH = Rails.root.join('tmp/maintenance.txt')

  def self.start
    FileUtils.touch MAINTENANCE_FILE_PATH
  end

  def self.stop
    FileUtils.rm_f MAINTENANCE_FILE_PATH
  end

  def self.status?
    File.exist? MAINTENANCE_FILE_PATH
  end
end
