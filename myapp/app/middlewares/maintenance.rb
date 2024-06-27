# frozen_string_literal: true

# app/middleware/maintenance.rb
class Maintenance
  def initialize(app)
    @app = app
  end

  def call(env)
    if File.exist?(Rails.root.join('tmp', 'maintenance_mode'))
      [302, { 'Location' => '/maintenance.html' }, []]
    else
      @app.call(env)
    end
  end
end
