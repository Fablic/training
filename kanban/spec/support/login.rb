def log_in_as(user)
  get login_path
  post login_path, params: { email: user.email, password: user.password }
end
