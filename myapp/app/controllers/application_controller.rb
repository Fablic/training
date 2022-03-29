# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  def render_404
    render file: Rails.root.join('public/404.html'), status: :not_found, content_type: 'text/html'
  end

    def logged_in_user
    if session[:user_id] == nil
      redirect_to login_form_path
    end
  end
end
