require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # 言語を日本語に設定
    config.i18n.default_locale = :ja
    # localeファイルの読み込み設定
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{yml}').to_s]

    # タイムゾーンを日本に設定
    config.time_zone = 'Tokyo'
    # DB側から受け取った時刻をローカルのタイムゾーンとして解釈するよう設定
    config.active_record.default_timezone = :local

    # スクリプトのパス
    config.autoload_paths += %W(#{config.root}/lib)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
