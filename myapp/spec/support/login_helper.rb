# frozen_string_literal: true

module LoginHelper
  def login(user: create(:user))
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end

RSpec.configure do |config|
  config.include LoginHelper
end
