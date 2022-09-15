class SystemMaintenance < ApplicationRecord
  enum status: {
    started: '1',
    stopped: '9',
  }

  KEY_TASK_MANAGEMENT = '1001'

  def self.is_started(key)
    SystemMaintenance.statuses[SystemMaintenance.find_by(key: key).status] == SystemMaintenance.statuses[:started] ? true : false
  end

  def self.is_stopped(key)
    SystemMaintenance.statuses[SystemMaintenance.find_by(key: key).status] == SystemMaintenance.statuses[:stopped] ? true : false
  end
end
