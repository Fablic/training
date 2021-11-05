# frozen_string_literal: true

class Batch::Maintenance
  # バッチを実行
  def self.on
    p 'put this system into maintenance mode...'

    Maintenance.all.destroy_all
    Maintenance.create(maintenance_on_flag: true)

    p 'The system is undere maintenance mode!'
  end

  def self.off
    p 'Release the maintenance mode'

    Maintenance.all.destroy_all

    p 'maintenance mode has been released!'
  end
end
