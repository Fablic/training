# frozen_string_literal: true
# rubocop:disable all

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TodoApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    config.i18n.default_locale = :en
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.generators do |g|
      g.assets false
      g.skip_routes false
      g.test_framework :rspec,
        controller_specs: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end
  end
end
