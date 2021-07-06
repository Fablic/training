# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    layout 'admin'
    before_action :find_user, only: %i[show edit update destroy]

    def index
      @users = User.includes(:tasks).page(params[:page])
    end

    def new
      @user = User.new
    end

    def show; end

    def edit; end

    def create

    end

    def update

    end

    def destroy

    end

    def tasks

    end

    private

    def find_user
      @user = User.joins(:tasks).find(params[:id])
    end
  end
end
