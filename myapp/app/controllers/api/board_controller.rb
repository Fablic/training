module Api
  class BoardController < ApplicationController
    def post
    end

    def get

      @board = Board.find(params[:board_id])
      render :json => @board, include: {
        priority: {
          only: [:id, :title, :sort]
        },
        status: {
          only: [:id, :title, :sort]
        },
        tag: {
          only: [:tag]
        }
      }

    end

    def update
    end

    def delete
    end

  end
end