require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
  end

  # タスクの一覧が表示される
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
    visit root_path
    click_link "Create Task"
    fill_in "Title", with:  "test title"
    fill_in "Description", with: "test description"
    fill_in "Expire at", with: "2022-06-10 12:00:00"
    click_button "Save"

    expect(page).to have_content "test title"
    expect(page).to have_content "test description"
    expect(page).to have_content "2022-06-10 12:00:00"

  end

  # titleが空欄だとタスクが作成できない
  it "can't create task if title is blank"
  
  # titleを編集できる
  it "edit title in the task"

  # titleが空欄だと更新できない
  it "can't edit if title is blank"

  # descriptionを編集できる
  it "edit title in the task"

  # expire_atを編集できる
  it "edit expire_at in the task"

  # 編集後にflashメッセージが表示される
  it "show flash message after edit"

  # タスク詳細が表示される
  it "show task detail"



end
