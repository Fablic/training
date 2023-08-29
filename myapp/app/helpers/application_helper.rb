module ApplicationHelper
  def maintenance_mode?
    Rails.application.config.maintenance_mode
  end
end
