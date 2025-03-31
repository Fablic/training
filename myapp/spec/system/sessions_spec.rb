require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  
  let(:user) { User.create(name: "Test User", username: "testuser", password: "password123") }

  describe "login page" do
    it "displays the login form" do
      visit login_path
      expect(page).to have_content(I18n.t 'page.login')
      expect(page).to have_field(I18n.t('username'))
      expect(page).to have_field(I18n.t('password'))
      expect(page).to have_button(I18n.t('button.login'))
    end
    it "User Login/Logout Successfully" do
      visit login_path
      fill_in I18n.t('username'), with: user.username
      fill_in I18n.t('password'), with: user.password
      click_button I18n.t('button.login')
      expect(page).to have_content(I18n.t("msg_login_success"))
      expect(page).to have_content(I18n.t 'page.task')
      expect(page).to have_content(user.name)
      click_link I18n.t("button.logout")
      expect(page).to have_content(I18n.t("msg_logout"))
      expect(page).to have_current_path(login_path(locale: I18n.locale))
    end
    it "User Login Failed" do
      visit login_path
      fill_in I18n.t('username'), with: user.username
      fill_in I18n.t('password'), with: "wrongpassword"
      click_button I18n.t('button.login')
      expect(page).to have_content(I18n.t("msg_invalid_username_or_password"))
    end
  end
end
