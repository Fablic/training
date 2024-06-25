class MaintenanceModeFilter # rubocop:disable Style/Documentation
  def initialize(app)
    @app = app
  end

  def call(env)
    if File.exist?(Rails.root.join('tmp', 'maintenance_mode_on'))
      [302, { 'Location' => '/maintenance' }, []]
    else
      @app.call(env)
    end
  end
end
