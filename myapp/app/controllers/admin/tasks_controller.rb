# frozen_string_literal: true

module Admin
  class TasksController < ApplicationController
    def index
      @user = User.find(params[:user_id])
      @tasks = @user.tasks
    end
  end
end
