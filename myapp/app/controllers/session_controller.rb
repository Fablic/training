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

  def change_role
    return if current_user.standard?

    update_opearatoin_role(role_params[:operation_role])
    redirect_to after_change_role_path_for(current_user)
  end

  private

  def update_opearatoin_role(operation_role)
    session[:operation_role] = nil
    if operation_role == 'standard'
      session[:operation_role] = 'standard'
      flash[:notice] = 'standardユーザへ切り替えました。'
    elsif operation_role == 'admin' && current_user.admin?
      session[:operation_role] = 'admin'
      flash[:notice] = 'adminユーザへ切り替えました。'
    end
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
