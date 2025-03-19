require 'rails_helper'

RSpec.describe "Tasks", type: :system do

  describe "Listing tasks" do
    context "when no tasks exist" do
      it "shows no task message" do
        visit tasks_path
        expect(page).to have_content("No Task") 
      end
    end

    context "when some tasks exist" do
      before do
        Task.create!(
          name: "Task One",
          description: "First task description",
          user_id: 1,
          created_at: 1.days.ago,
          deadline: 1.day.from_now,
          priority: "low",
          status: "to_do"
        )
        Task.create!(
          name: "Task Two",
          description: "Second task description",
          user_id: 1,
          created_at: 1.days.ago,
          deadline: 1.day.from_now,
          priority: "medium",
          status: "in_progress"
        )
      end

      it "displays the task list" do
        visit tasks_path
        expect(page).to have_content("Task One")
        expect(page).to have_content("Task Two")
      end
    end
  end

  describe "Creating a task" do
    context "with valid inputs" do
      it "creates a new task" do
        visit new_task_path

        fill_in I18n.t("name"), with: "New Task"
        fill_in I18n.t("description"), with: "This is a new task"
        select I18n.t("activerecord.attributes.task.priorities.low"), from: I18n.t("priority")
        select I18n.t("activerecord.attributes.task.statuses.to_do"), from: I18n.t("status")
        deadline = 7.days.from_now
        select deadline.year.to_s, from: "task_deadline_1i"
        select I18n.t("date.month_names")[deadline.month], from: "task_deadline_2i"
        select deadline.day.to_s, from: "task_deadline_3i"
        select deadline.strftime("%H"), from: "task_deadline_4i"
        select deadline.strftime("%M"), from: "task_deadline_5i"

        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t 'msg_create_success')
        expect(page).to have_content("New Task")
      end
    end

    context "without a name" do
      it "shows a name validation error" do
        visit new_task_path

        fill_in I18n.t("name"), with: ""
        fill_in I18n.t("description"), with: "Task without a name."
        select I18n.t("activerecord.attributes.task.priorities.low"), from: I18n.t("priority")
        select I18n.t("activerecord.attributes.task.statuses.to_do"), from: I18n.t("status")
        deadline = 7.days.from_now
        select deadline.year.to_s, from: "task_deadline_1i"
        select I18n.t("date.month_names")[deadline.month], from: "task_deadline_2i"
        select deadline.day.to_s, from: "task_deadline_3i"
        select deadline.strftime("%H"), from: "task_deadline_4i"
        select deadline.strftime("%M"), from: "task_deadline_5i"

        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t("activerecord.attributes.task.name") + " " + I18n.t("errors.messages.blank"))
      end
    end

    context "without a deadline" do
      it "shows a deadline validation error" do
        visit new_task_path

        fill_in I18n.t("name"), with: "New Task"
        fill_in I18n.t("description"), with: "Task without a deadline."
        select I18n.t("activerecord.attributes.task.priorities.low"), from: I18n.t("priority")
        select I18n.t("activerecord.attributes.task.statuses.to_do"), from: I18n.t("status")

        click_button I18n.t("button.save")

        expect(page).to have_content(I18n.t("activerecord.attributes.task.deadline") + " " + I18n.t("errors.messages.blank"))
      end
    end
  end

  describe "Editing a task" do
    let!(:task) do
      Task.create!(
        name: "Original Task",
        description: "Task to be edited",
        user_id: 1,
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
  end

  describe "Deleting a task" do
    let!(:task) do
      Task.create!(
        name: "Delete Me",
        description: "Task to be deleted",
        user_id: 1,
        created_at: 1.days.ago,
        deadline: 1.day.from_now,
        priority: "medium",
        status: "to_do"
      )
    end

    it "deletes the task and shows success message" do
      visit tasks_path

      click_link "Delete", href: task_path(locale: I18n.locale, id: task.id)

      expect(page).to have_content(I18n.t 'msg_delete_success')
    end
  end
end
