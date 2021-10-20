# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |g|
      # Railsジェネレータがfactory_bot用のファイルを生成するのを無効化
      g.factory_bot false

      # ファクトリファイルの置き場を変更
      g.factory_bot dir: 'test/factories'

      config.time_zone = 'Tokyo'
      config.active_record.default_timezone = :local
    end
  end
end
