# frozen_string_literal: true

module Admin
  class UsersController < Admin::AdminBase
    def index
      @app_users = AppUser.all.includes(:tasks).page(params[:page]).per(10)
    end

    def new
      @app_user = AppUser.new
    end

    # rubocop:disable Metrics/AbcSize
    def create
      @app_user = AppUser.new(user_params.merge({ start_date: Time.zone.now, suspended: false }))

      if params[:app_user][:password] && (params[:app_user][:password] != params[:app_user][:password_confirm])
        flash.alert = t('err-pass-not-match')
        return render 'new'
      end

      if @app_user.save
        flash.notice = as_success_message(@app_user.name, 'action-create')

        redirect_to admin_users_path
      else
        flash.alert = error_message
        render 'new'
      end
    end
    # rubocop:enable Metrics/AbcSize

    def destroy
      @app_user = AppUser.find(params[:id])

      raise IllegalAccessError, 'Unexpected Operation' if @app_user.admin?
      raise ActiveRecord::ActiveRecordError, 'Delete user failed' unless @app_user.destroy!

      respond_to do |format|
        format.js
      end
    end

    def suspend
      @app_user = AppUser.find(params[:user_id])
      @app_user.toggle(:suspended).save

      respond_to do |format|
        format.js
      end
    end

    private

    def user_params
      params.require(:app_user).permit(:name, :password)
    end

    def as_success_message(name, action_key)
      t('user-success', name: name, action: t(action_key))
    end

    def error_message
      t('msg-error')
    end
  end
end
