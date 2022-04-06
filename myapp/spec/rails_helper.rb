ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Capybara.register_driver :remote_chrome do |app|
    url = "http://chrome:4444/wd/hub"
    caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
      "goog:chromeOptions" => {
        "args" => [
          "no-sandbox",
          "headless",
          "disable-gpu",
          "window-size=1680,1050"
        ]
      }
    )
    Capybara::Selenium::Driver.new(app, browser: :remote, url: url, desired_capabilities: caps)
  end

  RSpec.configure do |config|

    config.include FactoryBot::Syntax::Methods
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.before(:all) do
      DatabaseCleaner.start
    end

    config.after(:all) do
      DatabaseCleaner.clean
    end

    config.before(:each, type: :system) do
      DatabaseCleaner.start
      driven_by :selenium, using: :headless_chrome, screen_size: [1280, 800], options: { args: ["headless", "disable-gpu", "no-sandbox", "disable-dev-shm-usage"] }
    end

    config.before(:each, type: :system, js: true) do
      DatabaseCleaner.start
      driven_by :remote_chrome
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
      Capybara.server_port = 3001
      Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
    end
  end
