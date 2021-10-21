module LoginSupport
  def valid_login(user)
    visit sessions_login_path
    fill_in('Mail address', with: user.mail_address)
    fill_in('Password', with: user.password)
    click_button('login')
  end
end
RSpec.configure do |config|
  config.include LoginSupport
end
