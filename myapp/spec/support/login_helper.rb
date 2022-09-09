module LoginHelper
  def login(user, password)
    visit login_path
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: password
    click_on I18n.t('button.login')
  end
end
