class SystemMaintenance < ApplicationRecord
  KEY_TASK_MANAGEMENT = '1001'

  def self.is_maintenance?(key)
    SystemMaintenance.find_by(key: key).maintenance_flg
  end
end
