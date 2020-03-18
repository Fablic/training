module LoginHelper
  def sign_in_with(user)
    visit sign_in_path
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: 'hoge123'
    click_on I18n.t('sessions.new.sign_in')
  end
end
