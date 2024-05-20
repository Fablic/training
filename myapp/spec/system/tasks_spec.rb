# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :system do
  before do
    # Create dummy data
    @tasks = []
    for i in 1..9
      @tasks.append({ title: "test title #{i}",
                     description: "test description #{i}",
                     created_at: i.days.ago })
    end
    @taskRecords = Task.create!(@tasks)
    @task = @taskRecords[0]
  end

  it "check order by creation date" do
    @tasks.sort { |a, b| b[:created_at] <=> a[:created_at] }
    visit tasks_path

    for i in 1..9
      expect(page.all("tr")[i]).to have_content @tasks[i - 1][:created_at].strftime("%F")
    end
  end

  it "create task" do
    visit new_task_path

    fill_in "task_title", with: "task title"
    fill_in "task_description", with: "task description"

    click_button "Create Task"

    expect(page).to have_content "Task created."
    expect(page).to have_content "task title"
    expect(page).to have_content "task description"
  end

  it "read task" do
    visit task_path(@task)

    expect(page).to have_content "test title 1"
    expect(page).to have_content "test description 1"
  end

  it "update task" do
    visit edit_task_path(@task)

    expect(page).to have_field "task_title", with: "test title 1"
    expect(page).to have_field "task_description", with: "test description 1"

    fill_in "task_title", with: "test task title changed"
    fill_in "task_description", with: "test task description changed"

    click_button "Update Task"

    expect(page).to have_content "test task title changed"
    expect(page).to have_content "test task description changed"
  end

  it "delete task" do
    visit tasks_path

    all("tr")[1].click_button "delete"

    expect(page).to_not have_content "test title 1"
  end
end
