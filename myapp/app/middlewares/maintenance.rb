# frozen_string_literal: true

# app/middleware/maintenance.rb
class Maintenance
  def initialize(app)
    @app = app
  end

  def call(env)
    if File.exist?('/myapp/maintenance.flag')
      [302, { 'Location' => '/maintenance' }, ['Maintenance mode activated']]
    else
      @app.call(env)
    end
  end
end
