class SessionsController < ApplicationController
  before_action :require_login, only: [:destory]

  def new
  end

  def create
    user = User.find(personal_id: params[:personal_id].downcase)
    if user && user.authenticate(params[:pass])
      log_in(user)
      redirect_to profile_path(@user)
    else
      false.now[:denger] = 'ユーザIDかパスワードが間違っています'
      render 'new'
    end
  end
  
  def destory
    log_out
    redirect_to login_path
  end
end
