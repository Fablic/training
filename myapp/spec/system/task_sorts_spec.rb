require 'rails_helper'

RSpec.describe "TaskSorts", type: :system do
  before do
    @task1 = Task.create!(
      name: "Task 1", 
      description: "First task description",
      user_id: 1,
      created_at: 3.days.ago,
      deadline: 5.day.from_now,
      priority: "low",
      status: "to do"
    )
    @task2 = Task.create!(
      name: "Task 2", 
      description: "Second task description",
      user_id: 1,
      created_at: 2.days.ago,
      deadline: 3.day.from_now,
      priority: "medium",
      status: "in progress"
    )
    @task3 = Task.create!(
      name: "Task 3", 
      description: "Third task description",
      user_id: 1,
      created_at: 1.days.ago,
      deadline: 1.day.from_now,
      priority: "high",
      status: "done"
    )
  end

  it "sorts tasks descending created_at when the down arrow is clicked" do
    visit tasks_path
    within("th", text: I18n.t('created_at')) do
      click_link "↓"
    end

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 3")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 1")
  end

  it "sorts tasks ascending created_at when the up arrow is clicked" do
    visit tasks_path
    within("th", text: I18n.t('created_at')) do
      click_link "↑"
    end

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 1")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 3")
  end

  it "sorts tasks descending deadline when the down arrow is clicked" do
    visit tasks_path
    within("th", text: I18n.t('deadline')) do
      click_link "↓"
    end

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 1")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 3")
  end

  it "sorts tasks ascending deadline when the up arrow is clicked" do
    visit tasks_path
    within("th", text: I18n.t('deadline')) do
      click_link "↑"
    end

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 3")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 1")
  end
end
