module LoginHelper
  def log_in(user)
    # user = create(:user)
    visit login_path
    fill_in 'session[name]', with: user.name
    fill_in 'session[password]', with: user.password
    click_on 'btn-login'
  end
end
