require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    config.load_defaults 6.0

    # TimeZoneを日本（東京）に設定
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # デフォルト言語を日本語に設定
    config.i18n.default_locale = :ja

    # 言語ファイルを階層ごとに設定するための記述
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
