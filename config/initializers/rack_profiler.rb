# frozen_string_literal: true

if Rails.env.development?
  require "rack-mini-profiler"

  Rack::MiniProfiler.config.position = "bottom-right"
end
