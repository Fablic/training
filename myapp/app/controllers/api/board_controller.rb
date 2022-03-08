module Api
  class BoardController < ApplicationController
    before_action :check_login

    def check_login
      if session[:user]
        @user = User.find(session[:user]['id'])
        return if @user
      end

      head 401
    end

    def show
      @board = Board.find(params[:id])
      return head 403 unless @user.get_permission_for(@board.id).can_read?

      render json: @board, include: {
        priority: {
          only: %i[id title sort]
        },
        status: {
          only: %i[id title sort],
          include: {
            to_status: {
              only: %i[id]
            }
          }
        },
        tag: {
          only: [:tag]
        }
      }
    end

    def update; end

    def delete; end
  end
end
