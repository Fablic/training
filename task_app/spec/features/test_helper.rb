# frozen_string_literal: true

module TestHelper
  def login(user, visit_path = nil)
    visit login_path
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_on('ログイン')
    visit visit_path if visit_path
  end
end
