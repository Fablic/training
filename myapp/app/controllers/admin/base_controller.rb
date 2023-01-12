module Admin
  class BaseController < ::ApplicationController
    before_action :authorize_user
    before_action :validate_admin

    private

    def validate_admin
      redirect_to root_path unless Current.user.is_admin
    end
  end
end
