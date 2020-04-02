require 'rails_helper'

RSpec.describe 'Tasks', type: :system  do
  let!(:user) { create(:user) }
  before do
    sign_in_with(user)
  end
  sleep 2
  let!(:test_task1) { create(:task1, due: Date.today,     created_at: DateTime.now,     user: user) }
  let!(:test_task2) { create(:task2, due: Date.today + 1, created_at: DateTime.now + 1, user: user) }
  let!(:test_task3) { create(:task3, due: Date.today + 2, created_at: DateTime.now + 2, user: user) }

  # 下記Exceptionが頻発するので暫定対応
  # Selenium::WebDriver::Error::StaleElementReferenceError:
  # 参考: https://abicky.net/2019/09/17/062506/
  def retry_on_stale_element_reference_error(&block)
    first_try = true
    begin
      block.call
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      $stderr.puts "Retry on StaleElementReferenceError"
      if first_try
        first_try = false
        retry
      end
      raise
    end
  end

  describe 'Task List Page' do
    it 'Tests of Layout' do
      visit root_path
      expect(page).to have_content I18n.t('tasks.index.title')
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:summary)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:priority)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:status)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:due)
      expect(all('thead tr')[0].text).to have_content Task.human_attribute_name(:created_at)
      expect(all('thead tr')[0].text).to have_no_content Task.human_attribute_name(:updated_at)
      expect(page).to have_content 'task1'
      expect(page).to have_content I18n.t('tasks.index.priority.highest')
      expect(page).to have_content I18n.t('tasks.index.status.open')
      expect(page).to have_content 'task2'
      expect(page).to have_content I18n.t('tasks.index.priority.middle')
      expect(page).to have_content I18n.t('tasks.index.status.review')
      expect(page).to have_content 'task3'
      expect(page).to have_content I18n.t('tasks.index.priority.lowest')
      expect(page).to have_content I18n.t('tasks.index.status.done')

      expect(Task.count).to eq 3
    end

    it 'record is sorted by created_at with desc order' do
      visit root_path
      expect(all('tbody tr')[0].text).to have_content test_task3.summary
      expect(all('tbody tr')[1].text).to have_content test_task2.summary
      expect(all('tbody tr')[2].text).to have_content test_task1.summary
    end

    it 'when sort by due with order desc' do
      visit root_path
      click_link 'due_desc'
      sleep 1
      due = page.all('.due')
      retry_on_stale_element_reference_error do
        expect(due[0].text).to eq test_task3.due.strftime("%Y/%m/%d")
        expect(due[1].text).to eq test_task2.due.strftime("%Y/%m/%d")
        expect(due[2].text).to eq test_task1.due.strftime("%Y/%m/%d")
      end
    end

    it 'when sort by due with order asc' do
      visit root_path
      click_link 'due_asc'
      sleep 1
      retry_on_stale_element_reference_error do
        due = page.all('.due')
        expect(due[0].text).to eq test_task1.due.strftime("%Y/%m/%d")
        expect(due[1].text).to eq test_task2.due.strftime("%Y/%m/%d")
        expect(due[2].text).to eq test_task3.due.strftime("%Y/%m/%d")
      end
    end

    it 'when sort by created_at with order desc' do
      visit root_path
      click_link 'created_desc'
      sleep 1
      expect(page).to have_content I18n.t('tasks.index.title')
      retry_on_stale_element_reference_error do
        created_at = page.all('.created_at')
        expect(created_at[0].text).to eq test_task3.created_at.strftime("%Y/%m/%d %H:%M:%S")
        expect(created_at[1].text).to eq test_task2.created_at.strftime("%Y/%m/%d %H:%M:%S")
        expect(created_at[2].text).to eq test_task1.created_at.strftime("%Y/%m/%d %H:%M:%S")
      end
    end

    it 'when sort by created_at with order asc' do
      visit root_path
      click_link 'created_asc'
      sleep 1
      retry_on_stale_element_reference_error do
        created_at = page.all('.created_at')
        expect(created_at[0].text).to eq test_task1.created_at.strftime("%Y/%m/%d %H:%M:%S")
        expect(created_at[1].text).to eq test_task2.created_at.strftime("%Y/%m/%d %H:%M:%S")
        expect(created_at[2].text).to eq test_task3.created_at.strftime("%Y/%m/%d %H:%M:%S")
      end
    end

    describe 'search' do
      context 'by summary with keyword contained in only one record' do
        before do
          visit tasks_path
          fill_in Task.human_attribute_name(:summary), with: 'task1'
          click_on I18n.t('action.search.task')
        end

        it 'should find task1' do
          summary = page.all('.summary')
          expect(summary.size).to eq (1)
          expect(page).to have_content 'task1'
          expect(page).to have_no_content 'task2'
          expect(page).to have_no_content 'task3'
        end
      end

      context 'by summary with keyword contained in all record' do
        before do
          visit tasks_path
          fill_in Task.human_attribute_name(:summary), with: 'task'
          click_on I18n.t('action.search.task')
        end

        it 'should find task1, task2, task3' do
          summary = page.all('.summary')
          expect(summary.size).to eq (3)
          expect(page).to have_content 'task1'
          expect(page).to have_content 'task2'
          expect(page).to have_content 'task3'
        end
      end

      context 'by summary with keyword not contained in any record' do
        before do
          visit tasks_path
          fill_in Task.human_attribute_name(:summary), with: 'hoge'
          click_on I18n.t('action.search.task')
        end

        it 'should not find anything' do
          summary = page.all('.summary')
          expect(summary.size).to eq (0)
          expect(page).to have_no_content 'task1'
          expect(page).to have_no_content 'task2'
          expect(page).to have_no_content 'task3'
        end
      end

      context 'by status with select valid value in only one record' do
        before do
          visit tasks_path
          select I18n.t('tasks.index.status.done'), from: "search_status"
          click_on I18n.t('action.search.task')
        end

        it 'should find task3' do
          status = page.all('.status')
          expect(status.size).to eq (1)
          expect(status[0].text).to eq  I18n.t('tasks.index.status.done')
          expect(page).to have_no_content 'task1'
          expect(page).to have_no_content 'task2'
          expect(page).to have_content 'task3'
        end
      end

      context 'by status with select invalid value in any record' do
        before do
          visit tasks_path
          select I18n.t('tasks.index.status.reopen'), from: "search_status"
          click_on I18n.t('action.search.task')
        end

        it 'should find task3' do
          status = page.all('.status')
          expect(status.size).to eq (0)
          expect(page).to have_no_content 'task1'
          expect(page).to have_no_content 'task2'
          expect(page).to have_no_content 'task3'
        end
      end
    end

    describe 'pagenation' do
      context 'when there are several pages' do
        let!(:task) { create_list(:task1, 30, user: user ) }
        it 'should transrate next page' do
          visit tasks_path
          expect(page).to have_link 2, href: tasks_path(page: 2)
          expect(page).to have_link 3, href: tasks_path(page: 3)
        end

        it 'should transrate previous page' do
          visit tasks_path(page: 2)
          expect(page).to have_link 1, href: tasks_path
        end
      end
    end

    it 'Tests of Click Draft Anchor Link' do
      visit root_path
      click_on I18n.t('action.create')
      expect(current_path).to eq new_task_path
      expect(page).to have_content I18n.t('tasks.new.title')
      expect(find_field(Task.human_attribute_name(:summary)).value).to be_empty
      expect(find_field(Task.human_attribute_name(:description)).value).to be_empty
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.middle'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('flash.selector', item: Task.human_attribute_name(:status)))
      expect(find_field(Task.human_attribute_name(:due)).value).to be_empty
    end

    it 'Test of Click Detail Anchor Link' do
      visit root_path
      click_link I18n.t('action.detail'), match: :first
      expect(current_path).to eq task_path(test_task3)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: test_task3.id)
      expect(page).to have_content 'task3'
      expect(page).to have_content 'this is 3rd task'
      expect(page).to have_content I18n.t('tasks.index.priority.lowest')
      expect(page).to have_content I18n.t('tasks.index.status.done')
    end

    it 'Test of Click Edit Anchor Link' do
      visit root_path
      click_link I18n.t('action.update'), match: :first
      expect(current_path).to eq edit_task_path(test_task3)
      expect(page).to have_content I18n.t('tasks.edit.title', task_id: test_task3.id)
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq 'task3'
      expect(find_field(Task.human_attribute_name(:description)).value).to eq 'this is 3rd task'
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.lowest'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('tasks.index.status.done'))
    end
  end

  describe 'Task Registration Page' do
    let(:regist_task) { Task.create( summary: 'task4', description: 'this is 4th task', priority: 2, status: 2 ) }
    it 'displays default settings' do
      visit new_task_path
      expect(page).to have_content I18n.t('tasks.new.title')
      expect(find_field(Task.human_attribute_name(:summary)).value).to be_empty
      expect(find_field(Task.human_attribute_name(:description)).value).to be_empty
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.middle'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('flash.selector', item: Task.human_attribute_name(:status)))
      expect(find_field(Task.human_attribute_name(:due)).value).to be_empty
    end

    it 'is clicked Submit Button if set up normaly' do
      visit new_task_path
      expect {
        fill_in Task.human_attribute_name(:summary), with: 'regist_task'
        fill_in Task.human_attribute_name(:description), with: 'this is regist task'
        within find_field(Task.human_attribute_name(:priority)) do
          find("option[value='higher']").select_option
        end
        within find_field(Task.human_attribute_name(:status)) do
          find("option[value='reopen']").select_option
        end
        click_on I18n.t('action.create')
      }.to change { Task.count }.by(1)
      expect(current_path).to eq task_path(Task.maximum(:id))
      expect(page).to have_content I18n.t('tasks.show.title', task_id: Task.maximum(:id))
      expect(page).to have_content 'regist_task'
      expect(page).to have_content 'this is regist task'
    end

    it 'Test of Click Back Anchor Link' do
      visit new_task_path
      click_on I18n.t('action.back')
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('tasks.index.title')
    end
  end

  describe 'Task Editional Page' do
    it 'displays edit_task settings' do
      visit edit_task_path(test_task1)
      expect(page).to have_content I18n.t('tasks.edit.title', task_id: test_task1.id)
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq 'task1'
      expect(find_field(Task.human_attribute_name(:description)).value).to eq 'this is 1st task'
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.highest'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('tasks.index.status.open'))
      expect(find_field(Task.human_attribute_name(:due)).value).to eq test_task1.due.strftime("%Y-%m-%d")
    end

    it 'is clicked Submit Button if set up normaly' do
      visit edit_task_path(test_task1)
      expect {
        fill_in Task.human_attribute_name(:summary), with: test_task1.summary + '_edited'
        fill_in Task.human_attribute_name(:description), with: test_task1.description + '_edited'
        click_on I18n.t('action.update')
      }.to change { Task.count }.by(0)
      expect(current_path).to eq task_path(test_task1)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: test_task1.id)
      expect(page).to have_content 'task1_edited'
      expect(page).to have_content 'this is 1st task_edited'
    end

    it 'is clicked Back Anchor Link' do
      visit edit_task_path(Task.maximum(:id))
      click_on I18n.t('action.back')
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('tasks.index.title')
    end

    it 'is clicked Delete Anchor Link and Cancel' do
      visit edit_task_path(test_task3)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content I18n.t('tasks.edit.title', task_id: test_task3.id )
      }.to change { Task.count }.by (0)
      expect(current_path).to eq edit_task_path(test_task3)
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq 'task3'
      expect(find_field(Task.human_attribute_name(:description)).value).to eq 'this is 3rd task'
    end

    it 'is clicked Delete Anchor Link and OK' do
      visit edit_task_path(test_task3)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content I18n.t('tasks.index.title')
      }.to change { Task.count }.by (-1)
      expect(current_path).to eq tasks_path # root_path
      expect(page).to have_no_content 'task3'
    end
  end

  describe 'Task Detail Page' do
    it 'displays test_task1 settings' do
      visit task_path(test_task1)
      expect(page).to have_content I18n.t('tasks.show.title', task_id: test_task1.id)
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
      expect(page).to have_content I18n.t('tasks.index.priority.highest')
      expect(page).to have_content I18n.t('tasks.index.status.open')
    end

    it 'is increase when click Edit anchor-link' do
      visit task_path(test_task1)
      click_on I18n.t('action.update')
      expect(current_path).to eq edit_task_path(test_task1)
      expect(page).to have_content I18n.t('tasks.edit.title', task_id: test_task1.id)
      expect(find_field(Task.human_attribute_name(:summary)).value).to eq 'task1'
      expect(find_field(Task.human_attribute_name(:description)).value).to eq 'this is 1st task'
      expect(page).to have_select(Task.human_attribute_name(:priority), selected: I18n.t('tasks.index.priority.highest'))
      expect(page).to have_select(Task.human_attribute_name(:status), selected: I18n.t('tasks.index.status.open'))
    end

    it 'Test of Click Back Anchor Link' do
      visit task_path(test_task1)
      click_on I18n.t('action.back')
      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('tasks.index.title')
    end

    it 'is clicked Delete Anchor Link and Cancel' do
      visit task_path(test_task1)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.dismiss
        expect(page).to have_content I18n.t('tasks.show.title', task_id: test_task1.id)
      }.to change { Task.count }.by (0)
      expect(current_path).to eq task_path(test_task1)
      expect(page).to have_content 'task1'
      expect(page).to have_content 'this is 1st task'
    end

    it 'is clicked Delete Anchor Link and OK' do
      visit task_path(test_task1)
      expect {
        click_on I18n.t('action.remove')
        expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('flash.remove.confirm')
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content I18n.t('tasks.index.title')
      }.to change { Task.count }.by (-1)
      expect(current_path).to eq tasks_path # root_pathに変更予定
      expect(page).to have_no_content 'task1'
    end
  end
end
