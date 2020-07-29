# frozen_string_literal: true

module Admin
  class AdminBase < ApplicationController
    before_action :check_admin

    def check_admin
      raise IllegalAccessError unless current_user.admin?
    end
  end
end
