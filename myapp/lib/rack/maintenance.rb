class Rack::Maintenance
  MAINTENANCE_STATUS_CODE = 503
  MAINTENANCE_YAML = Rails.root.join('tmp', 'maintenance.yml')

  def initialize(app)
    @app = app
    @content = Rails.root.join('public', 'maintenance.html').read
  end

  def call(env)
    if MAINTENANCE_YAML.file?
      opts = YAML.safe_load(MAINTENANCE_YAML.read, symbolize_names: true)
      [MAINTENANCE_STATUS_CODE, headers(opts || {}), [@content]]
    else
      @app.call(env)
    end
  end

  private

  def headers(opts)
    {
      'Content-Type' => 'text/html',
      'Retry-After' => opts.fetch(:retry_after).to_s,
    }
  end
end
