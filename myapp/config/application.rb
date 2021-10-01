require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    
    #タイムゾーン設定を日本にする
    config.time_zone = 'Asia/Tokyo'
    # activeレコード用のtimezoneも同じく
    config.active_record.default_timezone = :local

    #デフォルトロケールを日本にする
    config.i18n.default_locale = :ja

    # 複数のロケールファイルを読み込めるようにする。
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
