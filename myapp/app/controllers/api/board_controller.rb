module Api
  class BoardController < ApplicationController
    def post; end

    def show
      @board = Board.find(params[:id])
      render json: @board, include: {
        priority: {
          only: %i[id title sort]
        },
        status: {
          only: %i[id title sort]
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
