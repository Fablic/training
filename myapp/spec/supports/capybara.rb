# frozen_string_literal: true

Capybara.server_host = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
Capybara.server_port = 3000

Capybara.register_driver :selenium_remote do |app|
  url = 'http://selenium-chrome:4444/wd/hub'
  opts = { desired_capabilities: :chrome, browser: :remote, url: url }
  driver = Capybara::Selenium::Driver.new(app, opts)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
