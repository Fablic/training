# frozen_string_literal: true

module Admin
  class TasksController < BaseController
    before_action :set_user

    def index
      @tasks = Task.where(user: @user).includes(:user, :limited_tags).page(params[:page])
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
