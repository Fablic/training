require 'rails_helper'

RSpec.describe "Admin Tasks", type: :system do
  let!(:admin) { User.create(name: "Admin", username: "admin", password: "password123", is_admin: true) }
  let!(:user1) { User.create(name: "User1", username: "user1", password: "password123") }
  def log_in(user)
    visit login_path(locale: I18n.locale)
    fill_in I18n.t("username"), with: user.username
    fill_in I18n.t("password"), with: user.password
    click_button I18n.t("button.login")
  end
  before { log_in(admin) }

  describe "Listing tasks" do
    context "when no tasks exist" do
      it "shows no task message" do
        visit admin_tasks_path
        expect(page).to have_content(I18n.t 'page.no_task') 
      end
    end
    context "when some tasks exist" do
      before do
        Task.create!(
          name: "Task One",
          description: "First task description",
          user: user1,
          created_at: 1.days.ago,
          deadline: 1.day.from_now,
          priority: "low",
          status: "to_do"
        )
        Task.create!(
          name: "Task Two",
          description: "Second task description",
          user: admin,
          created_at: 2.days.ago,
          deadline: 2.day.from_now,
          priority: "medium",
          status: "in_progress"
        )
      end
      it "displays all task list" do
        visit admin_tasks_path
        expect(page).to have_content("Task One")
        expect(page).to have_content("Task Two")
      end
    end
  end
  describe "Editing a task" do
    let!(:task) do
      Task.create!(
        name: "Original Task",
        description: "Task to be edited",
        user: admin,
        deadline: 1.day.from_now,
        priority: "low",
        status: "to_do"
      )
    end
    it "allows editing and displays success message" do
      visit edit_task_path(locale: I18n.locale, id: task.id)

      fill_in I18n.t("name"), with: "Edited Task"
      click_button I18n.t("button.save")

      expect(page).to have_content(I18n.t 'msg_update_success')
      expect(page).to have_content("Edited Task")
    end
    it "allows admin to reassign task" do
      visit edit_task_path(locale: I18n.locale, id: task.id)

      select user1.name, from: "task_user_id"
      click_button I18n.t("button.save")

      expect(page).to have_content(I18n.t 'msg_update_success')
      expect(page).to have_content(user1.name)
    end
  end
end
