module LoginHelpers
  def log_in_as(user)
    visit root_path
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    find('#login_button').click
  end
end
