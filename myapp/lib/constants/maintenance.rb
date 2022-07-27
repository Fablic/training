# frozen_string_literal: true

module Constants
  class Maintenance
    def self.on
      maintenance_mode = Constant.find_by(key: 'maintenance_mode')
      maintenance_mode.update(value: 'true')
    end

    def self.off
      maintenance_mode = Constant.find_by(key: 'maintenance_mode')
      maintenance_mode.update(value: 'false')
    end
  end
end
