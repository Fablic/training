ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'rake'

Rails.application.load_tasks

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include RequestHelper

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    Rails.application.load_seed
  end

  config.before(:each) do |example|
    I18n.locale = :en

    if example.metadata[:type] == :system
      config.include CapybaraHelper

      if ENV.key?('CAPYBARA_SERVER_PORT') && ENV.key?('CAPYBARA_HOST_NAME') && ENV.key?('CAPYBARA_SELENIUM_URL')
        Capybara.server_host = '0.0.0.0'
        Capybara.server_port = ENV.fetch('CAPYBARA_SERVER_PORT')
        Capybara.app_host = "http://#{ENV.fetch('CAPYBARA_HOST_NAME')}:#{Capybara.server_port}"

        driven_by :selenium, using: :chrome, options: { browser: :remote, url: ENV.fetch('CAPYBARA_SELENIUM_URL'), desired_capabilities: :chrome }
      else
        driven_by :selenium, using: :headless_chrome
      end
    end
  end
end

RSpec::Matchers.define_negated_matcher :not_change, :change
