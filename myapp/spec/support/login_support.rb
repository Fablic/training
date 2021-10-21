module LoginSupport
  def valid_login(user)
    exec_login(user.mail_address, user.password)
  end

  def exec_login(mail, pass)
    visit sessions_login_path
    fill_in('Mail address', with: mail)
    fill_in('Password', with: pass)
    click_button('login')
  end
end
RSpec.configure do |config|
  config.include LoginSupport
end
