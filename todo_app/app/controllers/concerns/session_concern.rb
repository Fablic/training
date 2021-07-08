# frozen_string_literal: true

require 'active_support'

module SessionConcern
  extend ActiveSupport::Concern

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
  end
end
