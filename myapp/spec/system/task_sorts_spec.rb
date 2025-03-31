require 'rails_helper'

RSpec.describe "TaskSorts", type: :system do
  let(:user) { User.create(name: "Test User", username: "testuser", password: "password123") }
  def log_in(user)
    visit login_path(locale: I18n.locale)
    fill_in I18n.t("username"), with: user.username
    fill_in I18n.t("password"), with: "password123"
    click_button I18n.t("button.login")
  end
  before { log_in(user) }
  before do
    Task.create!(
      name: "Task 1", 
      description: "First task description",
      user: user,
      created_at: 3.days.ago,
      deadline: 5.day.from_now,
      priority: "low",
      status: "to_do"
    )
    Task.create!(
      name: "Task 2", 
      description: "Second task description",
      user: user,
      created_at: 2.days.ago,
      deadline: 3.day.from_now,
      priority: "medium",
      status: "in_progress"
    )
    Task.create!(
      name: "Task 3", 
      description: "Third task description",
      user: user,
      created_at: 1.days.ago,
      deadline: 1.day.from_now,
      priority: "high",
      status: "in_progress"
    )
  end

  it "sorts tasks created_at" do
    visit tasks_path
    # default asc
    click_on I18n.t('created_at') # desc

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 3")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 1")

    click_on I18n.t('created_at') # asc

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 1")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 3")
  end

  it "sorts tasks deadline" do
    visit tasks_path
    click_on I18n.t('deadline') # asc

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 3")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 1")

    click_on I18n.t('deadline') # desc

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 1")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 3")
  end

  it "sorts tasks priority" do
    visit tasks_path
    click_on I18n.t('priority') # asc

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 1")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 3")

    click_on I18n.t('priority') # desc

    rows = all("table tbody tr")
    expect(rows[0]).to have_content("Task 3")
    expect(rows[1]).to have_content("Task 2")
    expect(rows[2]).to have_content("Task 1")
  end
end
