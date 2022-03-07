module Api
  class BoardController < ApplicationController
    def post; end

    def show
      # todo: get user from session
      user = User.get_temporary_user
      
      @board = Board.find(params[:id])
      throw 403 unless user.get_permission_for(@board.id).can_read?
      

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
