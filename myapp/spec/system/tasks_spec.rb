# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :system do
  before do
    @task = Task.create!(title: "test task title", description: "test task description")
  end

  it "create task" do
    visit new_task_path

    fill_in "task_title", with: "task title"
    fill_in "task_description", with: "task description"

    click_button I18n.t('tasks.new.create_button')

    expect(page).to have_content I18n.t('tasks.create.notice')
    expect(page).to have_content "task title"
    expect(page).to have_content "task description"
  end

  it "read task" do
    visit task_path(@task)

    expect(page).to have_content "test task title"
    expect(page).to have_content "test task description"
  end

  it "update task" do
    visit edit_task_path(@task)

    expect(page).to have_field "task_title", with: "test task title"
    expect(page).to have_field "task_description", with: "test task description"

    fill_in "task_title", with: "test task title changed"
    fill_in "task_description", with: "test task description changed"

    click_button I18n.t('tasks.edit.update_button')

    expect(page).to have_content "test task title changed"
    expect(page).to have_content "test task description changed"
  end

  it "delete task" do
    visit tasks_path

    all("tr")[1].click_button I18n.t('tasks.index.delete')

    expect(page).to_not have_content "test task title"
  end

  it "validation check empty" do
    visit new_task_path

    fill_in "task_title", with: ""

    click_button I18n.t('tasks.new.create_button')
    
    expect(page).to have_content I18n.t("tasks.create.alert")
  end

  it "validation check too many characters" do
    visit new_task_path

    fill_in "task_title", with: "X"*300
    fill_in "task_description", with: "Y"*30010

    click_button I18n.t('tasks.new.create_button')

    expect(page).to have_content I18n.t("tasks.create.alert")
  end
end
