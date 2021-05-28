class Rack::Maintenance
  MAINTENANCE_STATUS_CODE = 503
  MAINTENANCE_YAML = Rails.root.join('tmp', 'maintenance.yml')

  def self.start(retry_after)
    Rack::Maintenance::MAINTENANCE_YAML.write(
      YAML.dump(
        'retry_after' => retry_after,
      ),
    )
  end

  def self.finish
    FileUtils.rm_f(Rack::Maintenance::MAINTENANCE_YAML)
  end

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
