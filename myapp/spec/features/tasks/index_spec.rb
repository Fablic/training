# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '/tasks or /' do
  feature '#index' do
    feature 'tasks' do
      background do
        create(:task,
               name: 'aqua',
               end_date: end_date_aqua,
               priority: 'high',
               status: 'untouched',
               explanation: 'aqua hara')
        create(:task,
               name: 'kuma',
               end_date: end_date_kuma,
               priority: 'low',
               status: 'touched',
               explanation: 'brown kuma')
      end
      given(:end_date_aqua) { '2022/09/14 17:25' }
      given(:end_date_kuma) { '2022/09/13 18:25' }

      scenario 'correctly displays tasks' do
        visit root_path

        expect(current_path).to eq '/'

        expect(page).to have_content 'aqua'
        expect(page).to have_content end_date_aqua
        expect(page).to have_content '高'
        expect(page).to have_content '未着手'
        expect(page).to have_content 'aqua hara'

        expect(page).to have_content 'kuma'
        expect(page).to have_content end_date_kuma
        expect(page).to have_content '低'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'brown kuma'
      end
    end

    feature "with 'sort: id_desc' in search_params" do
      let!(:tasks) { create_list(:task, 11) }

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

    feature 'clicks link buttons' do
      background do
        create(:task,
               id: 1,
               name: 'aqua',
               end_date: end_date_aqua,
               priority: 'high',
               status: 'untouched',
               explanation: 'aqua hara')
      end
      background { create_list(:task, 3) }
      given(:end_date_aqua) { '2022/09/14 17:25' }

      scenario 'renders #new' do
        visit root_path
        click_on '新規作成する'

        expect(current_path).to eq '/tasks/new'
        expect(page).to have_content 'タスクの新規作成'
      end

      scenario 'renders #show' do
        visit root_path
        first(:link, '詳細を確認する').click

        expect(page).to have_content 'aqua'
        expect(page).to have_content end_date_aqua
        expect(page).to have_content '高'
        expect(page).to have_content '未着手'
        expect(page).to have_content 'aqua hara'
      end
    end
  end
end
