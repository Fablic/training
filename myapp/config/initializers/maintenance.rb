require 'rack/maintenance'

Rails.application.config.middleware.insert_after Rails::Rack::Logger, Rack::Maintenance
