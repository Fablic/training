module RequestHelpers
  include SessionsHelper

  def json
    JSON.parse(response.body)
  end

  def log_in_as(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button I18n.t('common.login')
  end

  def log_out
    delete logout_path
  end

  def signup(name: 'test_name', email: 'one@example.com', password: 'password', password_confirmation: 'password')
    fill_in I18n.t('activerecord.attributes.user.name'), with: name
    fill_in I18n.t('activerecord.attributes.user.email'), with: email
    fill_in I18n.t('activerecord.attributes.user.password'), with: password
    fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: password_confirmation
    click_button I18n.t('common.submit')
  end

  def login(email: 'one@example.com', password: 'password')
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button I18n.t('common.login')
  end
end
