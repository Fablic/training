require 'rails_helper'
require 'rake'

RSpec.describe Rack::Maintenance do
  let(:app) { ->(_env) { [200, {}, ['Hello']] } }
  let(:request) { Rack::MockRequest.env_for }

  def middleware(app)
    Rack::Lint.new(described_class.new(app))
  end

  def start_maintenance(retry_after)
    Rack::Maintenance.start(retry_after)
  end

  after do
    Rack::Maintenance.finish
  end

  it 'calls the next middleware/app' do
    response = middleware(app).call(request)
    expect(response[0]).to eq 200
    expect(response[1]).to eq({})
  end

  it 'does not call the next middleware/app and return the maintenance page' do
    start_maintenance(1800)

    response = middleware(app).call(request)
    expect(response[0]).to eq 503
    expect(response[1]).to eq({ 'Content-Type' => 'text/html', 'Retry-After' => '1800' })
  end
end
