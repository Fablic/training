# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :system do
  
  # Create dummy data
  let!(:tasks) do
    (1..9).map do |i|
      Task.create(title: "test title #{i}", description: "test description #{i}", created_at: i.days.ago)
    end
  end

  let!(:task) { tasks.first }

  describe "check order by creation date" do
    before do
      visit tasks_path
    end

    it "expect return desceding order" do
      for i in 1..9
        expect(page.all("tr")[i]).to have_content tasks[i - 1][:created_at].strftime("%Y-%m-%d %H:%M:%S")
      end
    end
  end

  it "create task" do
    visit new_task_path

    fill_in "task_title", with: "task title"
    fill_in "task_description", with: "task description"

    click_button '登録'

    expect(page).to have_content "作成"
    expect(page).to have_content "task title"
    expect(page).to have_content "task description"
  end

  it "read task" do
    visit task_path(task)

    expect(page).to have_content "test title 1"
    expect(page).to have_content "test description 1"
  end

  it "update task" do
    visit edit_task_path(task)

    expect(page).to have_field "task_title", with: "test title 1"
    expect(page).to have_field "task_description", with: "test description 1"

    fill_in "task_title", with: "test task title changed"
    fill_in "task_description", with: "test task description changed"

    click_button "更新"

    expect(page).to have_content "test task title changed"
    expect(page).to have_content "test task description changed"
  end

  it "delete task" do
    visit tasks_path

    all("tr")[1].click_button "削除"

    expect(page).to_not have_content "test title 1"
  end
end
