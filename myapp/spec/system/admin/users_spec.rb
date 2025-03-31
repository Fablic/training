require 'rails_helper'

RSpec.describe "Admin Users", type: :system do
  let!(:admin) { User.create(name: "Admin", username: "admin", password: "password123", is_admin: true) }
  let!(:user1) { User.create(name: "User1", username: "user1", password: "password123") }
  let!(:user2) { User.create(name: "User2", username: "user2", password: "password123") }
  let!(:task1) { Task.new(name: "Task 1", deadline: 1.day.from_now, priority: "low", status: "to_do", user: user1) }
  def log_in(user)
    visit login_path(locale: I18n.locale)
    fill_in I18n.t("username"), with: user.username
    fill_in I18n.t("password"), with: user.password
    click_button I18n.t("button.login")
  end
  before { log_in(admin) }

  it "shows the list of users" do
    click_link I18n.t("page.all_users")
    expect(page).to have_content(user1.username)
    expect(page).to have_content(user2.username)
    expect(page).to have_content(admin.username)
  end

  it "allows admin to create a new user" do
    click_link I18n.t("page.all_users")
    click_link I18n.t("button.new_user")
    fill_in I18n.t("name"), with: "New User"
    fill_in I18n.t("username"), with: "newusername"
    fill_in I18n.t("password"), with: "password123"
    click_button I18n.t("button.save")
    expect(page).to have_content("New User")
  end

  it "allows admin to soft delete a user" do
    click_link I18n.t("page.all_users")
    click_link "User2"
    click_link I18n.t("button.deactivate_user")
    expect(page).to_not have_content(user2.username)
  end

  it "allows admin to soft delete a user and their tasks" do
    click_link I18n.t("page.all_users")
    click_link "User1"
    click_link I18n.t("button.deactivate_user")
    expect(page).to_not have_content(user1.username)
    click_link I18n.t("page.all_tasks")
    expect(page).to_not have_content(task1.name)
  end

  it "not allow admin to edit and soft delete themselves" do
    click_link I18n.t("page.all_users")
    click_link "Admin"
    expect(page).to_not have_link(I18n.t("button.deactivate_user"))
    expect(page).to_not have_link(I18n.t("button.edit_user"))
  end
end
