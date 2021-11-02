require 'rails_helper'
require 'rake'

RSpec.describe type: :system do
  before(:all) do
    Rails.application.load_tasks
  end

  describe '#rake' do
    let(:start) { Rake.application['maintenance:start'] }
    let(:stop) { Rake.application['maintenance:stop'] }

    context 'When the maintenance is started.' do
      it do
        get login_url
        expect(response).to have_http_status(200)
        start.execute
        get login_url
        expect(response).to have_http_status(503)
      end
    end

    context 'When the maintenance is stoped.' do
      it do
        start.execute
        get login_url
        expect(response).to have_http_status(503)
        stop.execute
        get login_url
        expect(response).to have_http_status(200)
      end
    end
  end
end
