# frozen_string_literal: true

class Maintenance
  def initialize(app)
    @app = app
  end

  def call(env)
    if File.exist?(Rails.root.join('tmp', 'maintenance.lock'))
      return [503, { 'Content-Type' => 'application/json' }, [{ error: 'Service under maintenance' }.to_json]]
    end

    @app.call(env)
  end
end
