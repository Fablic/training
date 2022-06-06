class MemberController < ApplicationController
  def login

    token = cookies[:login_token]
    if cookies[:login_token]
      auto_login = UsersAutologin.find_by(token: cookies[:login_token])
      if auto_login
        session[:user] = auto_login.user
        redirect_to root_path
      end 
    end 

    @email = ''
  end

  def login_process
    @email = params[:email]
    password_entered = params[:password]

    user = User.find_by(email: @email)
    return redirect_to login_path unless user

    unless user
      @error_user = 'User not exists'
      return render 'login'
    end

    unless user.check_hash(password_entered)
      @error_password = 'wrong password'
      return render 'login'
    end

    if params[:remember_me]
      seed = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten

      token = (0...128).map {
        seed[rand(seed.length)]
      }.join

      auto_login = UsersAutologin.new(user: user, token: token)
      auto_login.save

      cookies[:login_token] = { value: token, expires: 30.days }
    end
    session[:user] = user
    redirect_to root_path

  end

  def logout
    user = User.find(session[:user]['id'])
    session[:user] = nil

    user.users_autologin.delete_all if user
    redirect_to login_path
  end 
end
