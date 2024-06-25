# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    # 在这里添加所有Admin命名空间下的控制器共通的逻辑
    # 例如，权限检查：
    before_action :check_admin

    private

    def check_admin
      redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
    end
  end
end
