# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :system do
  describe "test with dummy data" do
    let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
    let!(:rspec_session) { { user_id: user1.id } }

    # Create dummy data
    let!(:tasks) do
      (1..5).map do |i|
        Task.create(title: "test title #{i}",
                    description: "test description #{i}",
                    created_at: i.days.ago,
                    expiration_date: Time.now.since(i.days),
                    user_id: user1.id
                   )
      end
    end

    let!(:task) { tasks.first }

    describe "order" do
      before do
        visit tasks_path
      end

      it "expect created_at descending order" do
        tasks.each_with_index do |tsk, idx|
          expect(page.all("tr")[idx + 1]).to have_content tsk.created_at.strftime("%Y-%m-%d %H:%M:%S")
        end
      end

      it "expect expiration_date ascending order" do
        click_link I18n.t("activerecord.attributes.task.expiration_date")
        tasks.each_with_index do |tsk, idx|
          expect(page.all("tr")[-idx - 1]).to have_content tsk.expiration_date.strftime("%Y-%m-%d %H:%M:%S")
        end
      end
    end

    describe "read" do
      before do
        visit task_path(task)
      end

      it "expect showing the task detail" do
        expect(page).to have_content "test title 1"
        expect(page).to have_content "test description 1"
      end
    end

    describe "update" do
      before do
        visit edit_task_path(task)
      end

      it "expect the task updated" do
        fill_in "task_title", with: "test task title changed"
        fill_in "task_description", with: "test task description changed"

        click_button I18n.t("tasks.edit.update_button")

        expect(page).to have_content "test task title changed"
        expect(page).to have_content "test task description changed"
      end
    end

    describe "delete" do
      before do
        visit tasks_path
      end

      it "expect the task deleted" do
        all("tr")[1].click_button I18n.t("tasks.index.delete")
        expect(page).to_not have_content "test title 1"
      end
    end
  end

  describe "create" do
    let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
    let!(:rspec_session) { { user_id: user1.id } }
    before do
      visit new_task_path
    end

    it "expect showing the success message" do
      fill_in "task_title", with: "task title"
      fill_in "task_description", with: "task description"

      click_button I18n.t("tasks.new.create_button")

      expect(page).to have_content I18n.t("tasks.create.notice")
      expect(page).to have_content "task title"
      expect(page).to have_content "task description"
    end
  end

  describe "validation" do
    let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
    let!(:rspec_session) { { user_id: user1.id } }
    before do
      visit new_task_path
    end

    context "empty" do
      it "check the warning" do
        fill_in "task_title", with: ""

        click_button I18n.t("tasks.new.create_button")
        expect(page).to have_content "タイトルを入力してください"
      end
    end

    context "too many characters" do
      it "check the warnings" do
        fill_in "task_title", with: "X" * 110
        fill_in "task_description", with: "Y" * 30010

        click_button I18n.t("tasks.new.create_button")

        expect(page).to have_content "タイトルは100文字以内で入力してください"
        expect(page).to have_content "説明は30000文字以内で入力してください"
      end
    end
  end

  describe "search" do
    let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
    let!(:rspec_session) { { user_id: user1.id } }
    let!(:task1) { Task.create(title: "test title 1", user_id: user1.id) }
    let!(:task2) { Task.create(title: "test title 2", user_id: user1.id) }
    let!(:task3) { Task.create(title: "test title 3", user_id: user1.id) }
    before do
      visit tasks_path
    end
    context "title" do
      it "find a task with its title 'test title 1'" do
        fill_in "search", with: "test title 1"
        click_button I18n.t("tasks.index.filter")
        expect(Task.search_title("1")[0].title).to eq "test title 1"
      end
    end
  end

  describe "filter" do
    let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
    let!(:rspec_session) { { user_id: user1.id } }
    let!(:task1) { Task.create(title: "test title 1", status: "not_started", user_id: user1.id) }
    let!(:task2) { Task.create(title: "test title 2", status: "in_progress", user_id: user1.id) }
    let!(:task3) { Task.create(title: "test title 3", status: "completed", user_id: user1.id) }
    before do
      visit tasks_path
    end
    context "status" do
      it "find a task with its status 'in_progress'" do
        find("option[value='in_progress']").select_option
        click_button I18n.t("tasks.index.filter")
        expect(Task.filter_status("in_progress")[0].status).to eq "in_progress"
      end
    end
  end

  describe "pagination" do
    let!(:user1) { User.create(name: "user 1", email: "user1@example.com", password: "123") }
    let!(:rspec_session) { { user_id: user1.id } }
    let!(:tasks) do
      (1..20).map do |i|
        Task.create(title: "test title #{i}",
                    description: "test description #{i}",
                    user_id: user1.id)
      end
    end
    before do
      visit tasks_path
    end
    context "next page" do
      it "find tasks in the page 2" do
        tasks[0..4].each_with_index do |tsk, idx|
          expect(page.all("tr")[idx + 1]).to have_content tsk.created_at.strftime("%Y-%m-%d %H:%M:%S")
        end
        click_link I18n.t("views.pagination.next").tr(" &rsaquo;", "")
        tasks[5..9].each_with_index do |tsk, idx|
          expect(page.all("tr")[idx + 1]).to have_content tsk.created_at.strftime("%Y-%m-%d %H:%M:%S")
        end
      end
    end
    context "last page" do
      it "find tasks in the last page" do
        tasks[0..4].each_with_index do |tsk, idx|
          expect(page.all("tr")[idx + 1]).to have_content tsk.created_at.strftime("%Y-%m-%d %H:%M:%S")
        end
        click_link I18n.t("views.pagination.next").tr(" &rsaquo;", "")
        tasks[15..19].each_with_index do |tsk, idx|
          expect(page.all("tr")[idx + 1]).to have_content tsk.created_at.strftime("%Y-%m-%d %H:%M:%S")
        end
      end
    end
  end
end
