# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    User.find_by(id: session[:user_id])
  end

  def render_404
    render file: Rails.root.join('public/404.html'), status: :not_found, content_type: 'text/html'
  end
end
