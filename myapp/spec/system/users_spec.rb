# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :system do
  describe "Sign up" do
    context "create a user" do
      before do
        visit signup_path
      end
      it "valid" do
        fill_in "user_name", with: "user 1"
        fill_in "user_email", with: "user@example.com"
        fill_in "user_password", with: "123"
        
        click_button "Sign Up"
  
        expect(page).to have_content "user 1"
        expect(page).to have_content I18n.t("users.create.notice")
      end

      before do
        visit signup_path
      end
      it "not valid" do
        fill_in "user_name", with: "user 1"
        fill_in "user_email", with: "XXX"
        fill_in "user_password", with: "123"
        
        click_button "Sign Up"
  
        expect(page).to have_content I18n.t("users.create.alert")
      end
    end
  end

  describe "Login" do
    let!(:user1) { User.create(name: "user 1", email: "user@example.com", password: "123") }
    context "login a user" do
      before do
        visit login_path
      end
      it "valid" do
        fill_in "session_email", with: "user@example.com"
        fill_in "session_password", with: "123"
        
        click_button "Login"
  
        expect(page).to have_content "user 1"
        expect(page).to have_content I18n.t("sessions.create.notice")
      end

      before do
        visit login_path
      end
      it "valid" do
        fill_in "session_email", with: "user@example.com"
        fill_in "session_password", with: "XXXXXX"
        
        click_button "Login"
  
        expect(page).to have_content I18n.t("sessions.create.alert")
      end
    end
  end
end
