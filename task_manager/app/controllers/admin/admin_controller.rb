# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :authentification_admin

    def authentification_admin
      return if current_user.is_admin?

      flash[:danger] = I18n.t 'admin.flash.authentification_admin.danger'
      redirect_to root_path
    end
  end
end
