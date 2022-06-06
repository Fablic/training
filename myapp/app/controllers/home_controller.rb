class HomeController < ApplicationController
  def index
    # TODO: get user from session
    return redirect_to login_path unless session[:user]

    user = User.find(session[:user]['id'])
    return redirect_to login_path unless user

    # if user owns a board, redirect to that
    own_board = user.boards_user.find_by('permissions & 4')
    return redirect_to board_path({ "id": own_board.board.id }) if own_board

    # redirect to first board anything that user can view
    visible_board = user.boards_user.find_by('permissions & 1')
    return redirect_to board_path({ "id": visible_board.board.id }) if visible_board

    # otherwise, throw 403 because current user has no boards to see
    head 403
  end
end
