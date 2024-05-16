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
