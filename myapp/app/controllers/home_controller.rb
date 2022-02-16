class HomeController < ApplicationController
  def index
    #todo check auth, set proper board_id
    board_id = 1
    redirect_to "/board/" + String(board_id)
  end

end