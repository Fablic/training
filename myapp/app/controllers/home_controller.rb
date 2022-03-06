class HomeController < ApplicationController
  def index
    # TODO: check auth, set proper board_id
    board_id = 1
    redirect_to board_path(board_id)
  end
end
