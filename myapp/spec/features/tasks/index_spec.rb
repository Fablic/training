# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/tasks or /' do
  feature '#index' do
    feature 'without search_params' do
      let!(:tasks) { create_list(:task, 11) }

      scenario 'correctly displays tasks' do
        visit root_path

        expect(current_path).to eq '/'
        tasks.each do |task|
          expect(page).to have_content task.name.to_s
          expect(page).to have_content I18n.l(task.end_date).to_s
          expect(page).to have_content Task.priorities_i18n[task.priority]
          expect(page).to have_content Task.statuses_i18n[task.status]
          expect(page).to have_content task.explanation.to_s
        end
      end

      feature "with sorts 'id_desc' in search_params" do
        scenario 'correctly displays tasks' do
          visit tasks_path

          expect(current_path).to eq '/tasks'

          find("option[value='id_desc']").select_option
          click_on '送信'

          tasks.reverse.each_with_index do |task, i|
            expect(page.all('.task')[i].find('.task_name').text).to eq task.name.to_s
            expect(page.all('.task')[i].find('.task_end_date').text).to eq I18n.l(task.end_date).to_s
            expect(page.all('.task')[i].find('.task_priority').text).to eq Task.priorities_i18n[task.priority]
            expect(page.all('.task')[i].find('.task_status').text).to eq Task.statuses_i18n[task.status]
            expect(page.all('.task')[i].find('.task_explanation').text).to eq task.explanation.to_s
          end
        end
      end
    end

    feature 'clicks link buttons' do
      let!(:task) { create(:task) }

      scenario 'redirects to #new' do
        visit root_path
        click_on I18n.t('transition_destination.create')
        expect(current_path).to eq '/tasks/new'
        expect(page).to have_content 'タスクの新規作成'
      end

      scenario 'redirects to #show' do
        visit root_path
        first(:link, I18n.t('transition_destination.show')).click

        expect(current_path).to eq "/tasks/#{task.id}"
        expect(page).to have_content task.name.to_s
        expect(page).to have_content I18n.l(task.end_date).to_s
        expect(page).to have_content Task.priorities_i18n[task.priority].to_s
        expect(page).to have_content Task.statuses[task.status].to_s
        expect(page).to have_content task.explanation.to_s
      end
    end
  end
end
