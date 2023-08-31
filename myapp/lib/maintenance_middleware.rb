class MaintenanceMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if maintenance_mode_enabled?
      render_maintenance_page
    else
      @app.call(env)
    end
  end

  private

  def maintenance_mode_enabled?
    Rails.application.config.maintenance_mode
  end

  def render_maintenance_page
    [503, { 'Content-Type' => 'text/html' }, [File.read(Rails.public_path.join('maintenance.html'))]]
  end
end
