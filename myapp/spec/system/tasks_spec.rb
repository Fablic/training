# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :system do
  describe "login" do
    let!(:user1) { create(:user1) }
    before do
      visit login_path
      fill_in "session_email", with: "user1@example.com"
      fill_in "session_password", with: "123"
      click_button "Login"
    end
    describe "test with dummy data" do
      # Create dummy data
      let!(:task1) { create(:task1, user_id: user1.id) }
      let!(:task2) { create(:task2, user_id: user1.id) }
      let!(:task3) { create(:task3, user_id: user1.id) }
      let!(:task4) { create(:task4, user_id: user1.id) }
      let!(:task5) { create(:task5, user_id: user1.id) }
      let!(:task) { task1 }

      describe "order" do
        before do
          visit tasks_path
        end

        it "expect created_at descending order" do
          expect(page.all("tr")[1]).to have_content task5.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[2]).to have_content task4.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[3]).to have_content task3.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[4]).to have_content task2.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[5]).to have_content task1.created_at.strftime("%Y-%m-%d %H:%M:%S")
        end

        it "expect expiration_date ascending order" do
          click_link I18n.t("activerecord.attributes.task.expiration_date")
          # click_link I18n.t("activerecord.attributes.task.expiration_date")

          expect(page.all("tr")[1]).to have_content task1.expiration_date.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[2]).to have_content task2.expiration_date.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[3]).to have_content task3.expiration_date.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[4]).to have_content task4.expiration_date.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[5]).to have_content task5.expiration_date.strftime("%Y-%m-%d %H:%M:%S")
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          sleep 1
          retry
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
          all("tr")[5].click_button I18n.t("tasks.index.delete")
          page.driver.browser.switch_to.alert.accept
          expect(page).to_not have_content "test title 1"
        end
      end
    end

    describe "create" do
      before do
        visit login_path
        fill_in "session_email", with: "user1@example.com"
        fill_in "session_password", with: "123"
        click_button "Login"
      end
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
      let!(:task1) { create(:task1, user_id: user1.id) }
      let!(:task2) { create(:task2, user_id: user1.id) }
      let!(:task3) { create(:task3, user_id: user1.id) }
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
      let!(:task1) { create(:task1, user_id: user1.id) }
      let!(:task2) { create(:task2, user_id: user1.id) }
      let!(:task3) { create(:task3, user_id: user1.id) }
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
      let!(:task1) { create(:task1, user_id: user1.id) }
      let!(:task2) { create(:task2, user_id: user1.id) }
      let!(:task3) { create(:task3, user_id: user1.id) }
      let!(:task4) { create(:task4, user_id: user1.id) }
      let!(:task5) { create(:task5, user_id: user1.id) }
      let!(:task6) { create(:task6, user_id: user1.id) }
      let!(:task7) { create(:task7, user_id: user1.id) }
      before do
        visit tasks_path
      end
      context "next page" do
        it "find tasks in the page 2" do
          expect(page.all("tr")[1]).to have_content task7.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[2]).to have_content task6.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[3]).to have_content task5.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[4]).to have_content task4.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[5]).to have_content task3.created_at.strftime("%Y-%m-%d %H:%M:%S")

          begin
            click_link I18n.t("views.pagination.next").tr(" &rsaquo;", "")
            expect(page.all("tr")[1]).to have_content task2.created_at.strftime("%Y-%m-%d %H:%M:%S")
            expect(page.all("tr")[2]).to have_content task1.created_at.strftime("%Y-%m-%d %H:%M:%S")
          rescue Selenium::WebDriver::Error::StaleElementReferenceError
            sleep 1
            click_link I18n.t("views.pagination.previous").tr("&lsaquo; ", "")
            retry
          end
        end
      end
      context "last page" do
        it "find tasks in the last page" do
          expect(page.all("tr")[1]).to have_content task7.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[2]).to have_content task6.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[3]).to have_content task5.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[4]).to have_content task4.created_at.strftime("%Y-%m-%d %H:%M:%S")
          expect(page.all("tr")[5]).to have_content task3.created_at.strftime("%Y-%m-%d %H:%M:%S")

          begin
            click_link I18n.t("views.pagination.last").tr(" &rsaquo;", "")
            expect(page.all("tr")[1]).to have_content task2.created_at.strftime("%Y-%m-%d %H:%M:%S")
            expect(page.all("tr")[2]).to have_content task1.created_at.strftime("%Y-%m-%d %H:%M:%S")
          rescue Selenium::WebDriver::Error::StaleElementReferenceError
            sleep 1
            click_link I18n.t("views.pagination.previous").tr("&lsaquo; ", "")
            retry
          end
        end
      end
    end
  end
end
