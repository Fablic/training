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

    it "expect descending order" do
      tasks.each_with_index do |tsk, idx|
        expect(page.all("tr")[idx+1]).to have_content tsk[:created_at].strftime("%Y-%m-%d %H:%M:%S")
      end
    end
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

    click_button I18n.t('tasks.edit.update_button')

    expect(page).to have_content "test task title changed"
    expect(page).to have_content "test task description changed"
  end

  it "delete task" do
    visit tasks_path

    all("tr")[1].click_button I18n.t('tasks.index.delete')

    expect(page).to_not have_content "test title 1"
  end

  it "validation check empty" do
    visit new_task_path

    fill_in "task_title", with: ""

    click_button I18n.t('tasks.new.create_button')
    
    expect(page).to have_content 'タイトルを入力してください'
  end

  it "validation check too many characters" do
    visit new_task_path

    fill_in "task_title", with: "X"*300
    fill_in "task_description", with: "Y"*30010

    click_button I18n.t('tasks.new.create_button')

    expect(page).to have_content 'タイトルは255文字以内で入力してください'
    expect(page).to have_content '説明は30000文字以内で入力してください'

  end
end
