module RequestHelper
  def login_as(user)
    post '/login', params: { user: { name: user.name, password: user.password } }
  end

  def logout
    delete '/logout'
  end
end
