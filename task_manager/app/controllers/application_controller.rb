# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authenticate_user

  def authenticate_user
    if !logged_in?
      flash[:danger] = 'Please Login'
      redirect_to("/login")
    end
  end
end
