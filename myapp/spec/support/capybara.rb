Capybara.default_driver    = :selenium_chrome
Capybara.javascript_driver = :selenium_chrome
# Capybara.default_driver    = :rack_test
# Capybara.javascript_driver = :selenium_chrome_headless

Capybara.server_host = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
Capybara.server_port = 3001
Capybara.default_max_wait_time = 5
Capybara.ignore_hidden_elements = true

Capybara.register_driver :selenium_chrome do |app|
  opts = {
    desired_capabilities: :chrome,
    browser: :remote,
    url: 'http://chrome:4444/wd/hub'
  }
  Capybara::Selenium::Driver.new(app, opts)
end
