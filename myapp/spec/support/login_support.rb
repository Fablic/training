module LoginSupport
  def login(email, password)
    visit '/login'
    fill_in 'session[email]', with: email
    fill_in 'session[password]', with: password
    find('input[type="submit"]').click
    find('.alert') # login 処理完了まで待つための処理
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
