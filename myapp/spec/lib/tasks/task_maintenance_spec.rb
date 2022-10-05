# frozen_string_literal: true

require 'rake_helper'
require 'rails_helper'

RSpec.describe 'task_maintenance:start' do
  subject(:task) { Rake.application['task_maintenance:start'] }

  it 'change_to_maintenance_mode' do
    task.invoke
    visit login_path
    expect(page).to have_content '503'
  end
end
