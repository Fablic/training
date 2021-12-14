# frozen_string_literal: true

require 'rake'
require 'rails_helper'

RSpec.configure do |config|
  config.before(:suite) do
    # Load all the tasks just as Rails does (`load 'Rakefile'` is another simple way)
    Rails.application.load_tasks
  end

  config.before do
    # suppres stdout while testing
    allow($stdout).to receive(:write)

    Rake.application.tasks.each(&:reenable) # Remove persistency between examples
  end
end
