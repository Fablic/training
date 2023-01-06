# frozen_string_literal: true

require 'rails_helper'
require 'rake'
RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_tasks # 全てのrakeタスクを読み込む
  end

  config.before(:each) do
    Rake.application.tasks.each(&:reenable) # Remove persistency between examples
  end
end
