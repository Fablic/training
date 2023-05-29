module LoginSupport
  def login(email, password)
    visit login_path
    fill_in 'session[email]', with: email
    fill_in 'session[password]', with: password
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
