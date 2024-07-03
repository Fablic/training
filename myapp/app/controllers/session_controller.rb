# frozen_string_literal: true

class SessionController < ApplicationController # rubocop:disable Style/Documentation
  skip_before_action :require_sign_in!, :authorize_standard!

  layout 'session', only: %i[new create]

  def new
    ## new
  end

  def create
    user = User.find_by(name: params[:name])
    if sign_in(user)
      redirect_to after_sign_in_path_for(user), notice: I18n.t('session.sign_in_success')
    else
      flash.now[:alert] = I18n.t('session.invalid_message')
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to session_path, notice: I18n.t('session.sign_out_success')
  end

  private

  def sign_in(user)
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      return true
    end
    session[:user_id] = nil
    false
  end
end
