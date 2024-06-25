# frozen_string_literal: true

# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  # skip_before_action :require_admin, only: [:new, :create]
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: t('alerts.login_success')
    else
      redirect_to login_path, notice: t('alerts.login_failure')
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: t('alerts.logout_success')
  end
end
