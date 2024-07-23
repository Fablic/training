require 'rails_helper'

RSpec.describe 'Maintenance', type: :system do

  it 'Enable maintenance' do
    output = `rails runner scripts/enable_maintenance.rb`
    expect(output).to include('Maintenance mode enabled')

    visit '/'
    expect(page.status_code).to eq(503)

  end

  it 'Disable maintenance' do
    output = `rails runner scripts/disable_maintenance.rb`
    expect(output).to include('Maintenance mode is not enabled')

    visit '/'
    expect(page.status_code).to eq(200)

  end

  after do
    FileUtils.rm_f(Rails.root.join('tmp', 'maintenance.txt'))
  end
end
