# frozen_string_literal: true

Rails.application.config.middleware.use Maintenance
Rails.application.configure do
  config.maintenance_file = Rails.root.join('tmp', 'maintenance.lock')
end
