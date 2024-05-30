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

        click_button I18n.t("users.new.create_button")

        expect(page).to have_content "user 1"
        expect(page).to have_content I18n.t("users.create.notice")
      end

      before do
        visit signup_path
      end
      it "not valid" do
        fill_in "user_name", with: ""
        fill_in "user_email", with: "user@example.com"
        fill_in "user_password", with: "123"

        click_button I18n.t("users.new.create_button")

        expect(page).to have_content I18n.t("users.create.alert")
      end
    end
  end

  describe "Login" do
    let!(:user1) { create(:user1) }
    context "login a user" do
      before do
        visit login_path
      end
      it "valid" do
        fill_in "session_email", with: "user1@example.com"
        fill_in "session_password", with: "123"

        click_button "Login"

        expect(page).to have_content "user 1"
        expect(page).to have_content I18n.t("sessions.create.notice")
      end

      before do
        visit login_path
      end
      it "not valid" do
        fill_in "session_email", with: "user1@example.com"
        fill_in "session_password", with: "XXXXXX"

        click_button "Login"

        expect(page).to have_content I18n.t("sessions.create.alert")
      end
    end
  end

  describe "Admin" do
    let!(:user1) { create(:user1) }
    let!(:user2) { create(:user2) }
    let!(:user3) { create(:user3) }
    let!(:task1) { create(:task1, user_id: user1.id) }
    let!(:task2) { create(:task2, user_id: user1.id) }
    let!(:task3) { create(:task3, user_id: user1.id) }
    let!(:task4) { create(:task4, user_id: user1.id) }
    let!(:task5) { create(:task5, user_id: user1.id) }
    before do
      visit login_path
      fill_in "session_email", with: "user1@example.com"
      fill_in "session_password", with: "123"
      click_button "Login"
    end
    context "go to the list of users page" do
      before do
        visit users_path
      end
      it "find 3 users" do
        expect(page).to have_content user1.name
        expect(page).to have_content user2.name
        expect(page).to have_content user3.name
      end
    end

    context "go to the user detail page" do
      before do
        visit user_path(user1)
      end
      it "find the tasks" do
        expect(page).to have_content task1.title
        expect(page).to have_content task2.title
        expect(page).to have_content task3.title
        expect(page).to have_content task4.title
        expect(page).to have_content task5.title
      end

    end
  end
end
