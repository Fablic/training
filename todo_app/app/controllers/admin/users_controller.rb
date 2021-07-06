# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    layout 'admin'

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def edit; end

    def create

    end

    def update

    end

    def destroy

    end

    def tasks

    end
  end
end
