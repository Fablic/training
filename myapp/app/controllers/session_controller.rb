# frozen_string_literal: true

class SessionController < ApplicationController # rubocop:disable Style/Documentation
  skip_before_action :require_sign_in!, :authorize_standard_operation!

  layout 'session', only: %i[new create]

  def new
    ## new
  end

  def create
    user = sign_in(session_params)
    if user
      redirect_to after_sign_in_path_for(user), notice: I18n.t('session.sign_in_success')
    else
      flash.now[:alert] = I18n.t('session.invalid_message')
      render :new
    end
  end

  def destroy
    session[:id] = nil
    session[:opertion_role] = nil
    redirect_to session_path, notice: I18n.t('session.sign_out_success')
  end

  def switch_role
    return if current_user.standard?
    session[:operation_role] = nil

    operation_role = role_params[:operation_role]
    if operation_role == 'standard'
      switch_to_standard_role
    elsif operation_role == 'admin' && current_user.admin?
      switch_to_admin_role
    else
      handle_role_switch_failure
    end
    redirect_to after_change_role_path_for(current_user)
  end

  private

  def switch_to_standard_role
    session[:operation_role] = 'standard'
    flash[:notice] = I18n.t('session.switch_admin_role_success')
  end

  def switch_to_admin_role
    session[:operation_role] = 'admin'
    flash[:notice] = I18n.t('session.switch_standard_role_success')
  end

  def handle_role_switch_failure
    flash[:notice] = I18n.t('session.switch_role_failure')
  end

  def sign_in(session_params)
    user = User.find_by(name: session_params[:name])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      return user
    end
    session[:user_id] = nil
    nil
  end

  def session_params
    params.permit(:name, :password)
  end

  def role_params
    params.permit(:operation_role)
  end
end
