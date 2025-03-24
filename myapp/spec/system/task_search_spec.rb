require 'rails_helper'

RSpec.describe "TaskSearch", type: :system do
  before do
    Task.create!(
      name: "Task 1",
      description: "First task description",
      user_id: 1,
      created_at: 3.days.ago,
      deadline: 5.day.from_now,
      priority: "low",
      status: "to_do"
    )
    Task.create!(
      name: "Task 2",
      description: "Second task description",
      user_id: 1,
      created_at: 2.days.ago,
      deadline: 3.day.from_now,
      priority: "medium",
      status: "in_progress"
    )
    Task.create!(
      name: "Task 3",
      description: "Third task description",
      user_id: 1,
      created_at: 1.days.ago,
      deadline: 1.day.from_now,
      priority: "high",
      status: "in_progress"
    )
  end

  it "searches tasks by name" do
    visit tasks_path
    fill_in "q_name_or_description_cont", with: "Task 1"
    click_on I18n.t('button.search')

    expect(page).to have_content("Task 1")
    expect(page).to_not have_content("Task 2")
    expect(page).to_not have_content("Task 3")
  end

  it "searches tasks by description" do
    visit tasks_path
    fill_in "q_name_or_description_cont", with: "Third"
    click_on I18n.t('button.search')

    expect(page).to_not have_content("Task 1")
    expect(page).to_not have_content("Task 2")
    expect(page).to have_content("Task 3")
  end

  it "searches tasks by status" do
    visit tasks_path
    status_value = Task.statuses["to_do"] 
    find("input[name='q[status_in][]'][value='#{status_value}']", visible: false).click
    click_on I18n.t('button.search')

    expect(page).to have_content("Task 1")
    expect(page).to_not have_content("Task 2")
    expect(page).to_not have_content("Task 3")
  end

  it "searches tasks by name but not found" do
    visit tasks_path
    fill_in "q_name_or_description_cont", with: "Task 4"
    click_on I18n.t('button.search')

    expect(page).to have_content(I18n.t 'page.no_task')
  end

  it "sort parameter, status filters, and search form work together" do
    visit tasks_path
    click_on I18n.t('deadline') # asc
    status_value = Task.statuses["in_progress"] 
    find("input[name='q[status_in][]'][value='#{status_value}']", visible: false).click
    click_button I18n.t('button.search')

    expect(page).not_to have_content("Task 1")
    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 3")
    expect(rows[1]).to have_content("Task 2")

    fill_in "q_name_or_description_cont", with: "2"
    click_button I18n.t('button.search')
    expect(page).not_to have_content("Task 3")
    expect(page).to have_content("Task 2")
  end
end
