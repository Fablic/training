# frozen_string_literal: true

module ApplicationHelper
  def maintenance?
    File.exist?(maintenance_file_path)
  end

  def request_path
    Rails.application.routes.recognize_path(request.url)
  end

  def maintenance_file_path
    return application_maintenance_file if all_maintenance?

    Rails.root.join("app/views/#{request_path[:controller]}/maintenance.html.erb")
  end

  def application_maintenance_file
    Rails.root.join('app/views/layouts/maintenance.html.erb')
  end

  def all_maintenance?
    File.exist?(application_maintenance_file)
  end
end
