module Admin
  class TasksController < ApplicationController
    def show
      @tasks = Task.where(user_id: params[:id])
    end
  end
end
