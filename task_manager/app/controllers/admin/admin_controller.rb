# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :authentification_admin

    def authentification_admin
      return if current_user.is_admin?

      render_404
    end
  end
end
