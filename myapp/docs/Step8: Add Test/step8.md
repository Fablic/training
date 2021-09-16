# ステップ8: テスト(system spec)を書こう

- First make sure that these gems are exist in Gemfile
  ```
  group :test do
    gem 'capybara', '>= 2.15'
    gem 'selenium-webdriver'
  end
  ```
  **Note**: Remove the `webdrivers` gem from your Gemfile. If `webdrivers` is present, it will attempt to  find Chrome in your application’s container. 
  As Chrome isn’t installed  in the Dockerfile, the spec will fail.
  
- Before start testing we need to register a new driver with Capybara that is configured to use the Selenium container, add the below codes to 
  `spec/rails_helper.rb`
  ```
  Capybara.register_driver :remote_chrome do |app|
    hub_url = 'https://chrome:4444/wd/hub'
    chrome_capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:chromeOptions' => {
        'args' => %w[no-sandbox headless disable-gpu window-size=1680,1050],
      },
    )
    Capybara::Selenium::Driver.new(app, browser: :remote, url: hub_url, desired_capabilities: chrome_capabilities)
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 3000
    Capybara.app_host = "https://#{Capybara.server_host}:#{Capybara.server_port}"
  end
  ```
- specを書くための準備をしましょう
  - `spec/spec_helper.rb` 、 `spec/rails_helper.rb` を用意しましょう
- ~~feature spec~~ system specをタスク機能に対して書きましょう
  - Rails 5.1 以降、新たにsystem testの機能を追加しました
    - [日本語](https://qiita.com/jnchito/items/c7e6e7abf83598a6516d), [英語](https://rossta.net/blog/why-rails-system-tests-matter.html)
  - dockerを利用して研修を行う場合、以下の設定が必要です。
    1. [Dockerfile](https://qiita.com/ngron/items/f61b8635b4d67f666d75#failed-to-read-the-sessionstorage-property-from-window-storage-is-disabled-inside-data-urls)
    2. [spec/rails_helper.rb](https://commis.hatenablog.com/entry/2018/11/16/171608)
  - feature specですと `database_cleaner` という gemは必要でしたが、 system specに変更することで `database_cleaner` の導入が要らなくなった
- Circle CIなどのCIツールを導入して、Slackに通知するようにしましょう
  - Fablic/training内でPRのやり取りをする場合、CIツールの導入は任意(optional)です。CircleCIのAdmin権限が無いので、`.circleci/config.yml`を設定しても実行できないです。
- 参考書籍：https://leanpub.com/everydayrailsrspec-jp

## work log

### First make sure that these gems are exist in Gemfile

Look at A and make sure there is a corresponding statement.
```rb
group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end
```
Noteによると、`webdrivers`の記述がある場合は削除する必要がある  
理由: application conainer内のChromeを見つけようとするため(docker containerにchromeはinstallされていない)

### rspecの利用設定

Gemfileの`group :development, :test do`に以下の内容を追記
```rb
  gem 'rspec-rails', '~> 5.0.0' # https://github.com/rspec/rspec-rails
```
`bundle install`でrspecのモジュールを取得  
`rails generate rspec:install`でrspecに必要なファイル群の作成  
```txt
myapp
└ spec
    ┝ rails_helper.rb
    └ spec_helper.rb
```

### Before start testing we need to register a new driver with Capybara that is configured to use the Selenium container, add the below codes to `spec/rails_helper.rb`

rails_helper.rbに以下のconfig codeを貼り付け
```rb
Capybara.register_driver :remote_chrome do |app|
    hub_url = 'https://chrome:4444/wd/hub' # docker-compose.ymlでchromeのportを4444で設定しているため
    chrome_capabilities = ::Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:chromeOptions' => {
        'args' => %w[no-sandbox headless disable-gpu window-size=1680,1050],
      },
    )
    Capybara::Selenium::Driver.new(app, browser: :remote, url: hub_url, desired_capabilities: chrome_capabilities)
  end
  
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  
  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 3000
    Capybara.app_host = "https://#{Capybara.server_host}:#{Capybara.server_port}"
  end
```

### system specをタスク機能に対して書きましょう



## What I learn

### Capybaraとは？
E2Eテスティングフレームワーク(Webアプリ用のRails5.1から標準で入っている)
JSを使いたい場合はseleniumドライバを利用する必要がある  
この辺りかな
```rb (spec/rails_hepler)
config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 3000
    Capybara.app_host = "https://#{Capybara.server_host}:#{Capybara.server_port}"
  end
```

### Rspecとは？

Ruby向けのBDDツール、Gemパッケージとして提供されている
Capybaraで使う場合や中に内包されているものを利用する
`bundle exec rspec`で実行

### テストの作り方
[参考](https://qiita.com/tatsurou313/items/c923338d2e3c07dfd9ee)
#### テストファイルの命名規則
TBC
#### テストファイルの記述ルール
TBC
