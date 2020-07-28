# frozen_string_literal: true

class SessionController < ApplicationController
  def new
    session.delete(:current_user_id)
    @login_form = LoginForm.new
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @login_form = LoginForm.new(login_params)

    unless @login_form.valid?
      flash.alert = I18n.t('login-error')
      render 'new'
    end

    app_user = AppUser.find_by name: @login_form.name
    if app_user&.check_login(@login_form.pass)
      session[:current_user_id] = app_user.id
      flash.notice = I18n.t('logged-in')
      redirect_to tasks_path
    else
      flash.alert = I18n.t('login-error')
      render 'new'
    end
  end
  # rubocop:enable Metrics/AbcSize

  def destroy
    session.delete(:current_user_id)
    flash.notice = I18n.t('logged-out')
    redirect_to login_path
  end

  private

  def login_params
    params.require(:login_form).permit(:name, :pass)
  end
end
