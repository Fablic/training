# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.configure do |config|
  # すべてのタスクを読み込む
  config.before(:suite) do
    Rails.application.load_tasks
  end

  # タスクを毎回実行するようにする
  config.before(:each) do # rubocop:disable RSpec/HookArgument
    Rake.application.tasks.each(&:reenable)
  end
end
