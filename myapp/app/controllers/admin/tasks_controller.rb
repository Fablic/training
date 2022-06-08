module Admin
  class TasksController < ApplicationController
    before_action :logged_in_admin_user

    def show
      @tasks = Task.where(user_id: params[:id])
    end
  end
end
