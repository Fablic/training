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
          priority: "low",
          status: "to do"
        )
        Task.create!(
          name: "Task Two",
          description: "Second task description",
          user_id: 1,
          priority: "medium",
          status: "in progress"
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

        fill_in "Name", with: "New Task"
        fill_in "Description", with: "This is a new task"
        select "Low", from: "Priority"
        select "To do", from: "Status"

        click_button "Create Task"

        expect(page).to have_content("Task was successfully created")
        expect(page).to have_content("New Task")
      end
    end

    context "without a name" do
      it "shows a validation error" do
        visit new_task_path

        fill_in "Name", with: ""
        fill_in "Description", with: "Task without a name."
        select "Low", from: "Priority"
        select "To do", from: "Status"

        click_button "Create Task"

        expect(page).to have_content("Name can't be blank")
      end
    end
  end

  describe "Editing a task" do
    let!(:task) do
      Task.create!(
        name: "Original Task",
        description: "Task to be edited",
        user_id: 1,
        priority: "low",
        status: "to do"
      )
    end

    it "allows editing and displays success message" do
      visit edit_task_path(task)

      fill_in "Name", with: "Edited Task"
      click_button "Update Task"

      expect(page).to have_content("Task was successfully updated")
      expect(page).to have_content("Edited Task")
    end
  end

  describe "Deleting a task" do
    let!(:task) do
      Task.create!(
        name: "Delete Me",
        description: "Task to be deleted",
        user_id: 1,
        priority: "medium",
        status: "to do"
      )
    end

    it "deletes the task and shows success message" do
      visit tasks_path

      click_link "Delete", href: task_path(task)

      expect(page).to have_content("Task was successfully deleted")
    end
  end
end
