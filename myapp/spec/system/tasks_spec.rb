require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
  end

  # タスクの一覧が表示
  it "show all tasks" do
    task = FactoryBot.create(:task)
    visit root_path
    expect(page).to have_content task.title
    expect(page).to have_content task.description
    expect(page).to have_content task.expire_at
    expect(page).to have_content "Create Task"
    expect(page).to have_content "Edit"
    expect(page).to have_content "Delete"
  end

  # 新しいタスクを作成
  it "create a new task" do
    expect {
      visit root_path
      click_link "Create Task"
      fill_in "Title", with:  "test title"
      fill_in "Description", with: "test description"
      fill_in "Expire at", with: "2022-06-10 12:00:00"
      click_button "Save"
  
      expect(page).to have_content "Task created!"
      expect(page).to have_content "test title"
      expect(page).to have_content "test description"
      expect(page).to have_content "2022-06-10 12:00:00"
    }.to change(Task, :count).by(1)
  end

  # titleが空欄だとタスクが作成できない
  it "can't create task if title is blank" do
    visit root_path
    click_link "Create Task"
    fill_in "Description", with: "test description"
    fill_in "Expire at", with: "2022-06-10 12:00:00"
    click_button "Save"

    expect(page).to have_content ("Title can't be blank")
  end
  
  # 編集して更新できる
  it "update the task" do
    task = FactoryBot.create(:task)
    visit root_path
    click_link "Edit"
    fill_in "Title", with: "edited title"
    fill_in "Description", with: "edited desc"
    fill_in "Expire at", with: "2022-06-10 00:00:00"
    click_button "Save"

    expect(page).to have_content "Task updated!"
    expect(page).to have_content "edited title"
    expect(page).to have_content "edited desc"
    expect(page).to have_content "2022-06-10 00:00:00"
  end

  # titleが空欄だと更新できない
  it "can't update if the title is blank" do
    task = FactoryBot.create(:task)
    visit edit_task_path(task)
    fill_in "Title", with: ""
    click_button "Save"

    expect(page).to have_content ("Title can't be blank")
  end

  # タスク詳細が表示される
  it "show task detail" do
    task = FactoryBot.create(:task)
    visit root_path
    click_link task.title

    expect(page).to have_content "Task Detail"
    expect(page).to have_content task.title
    expect(page).to have_content task.description
    expect(page).to have_content task.expire_at
  end

  # タスクが削除できる
  it "delete task" do
    expect{
      task = FactoryBot.create(:task)
      visit root_path
      click_link "Delete"
    }.to change(Task, :count).by(0)
    expect(page).to have_content "Task deleted!"
  end

end
